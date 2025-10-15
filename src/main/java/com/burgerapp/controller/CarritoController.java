package com.burgerapp.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.burgerapp.model.ItemCarrito;
import com.burgerapp.model.Producto;
import com.burgerapp.service.ProductoService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/carrito")
public class CarritoController {
    @Autowired
    private ProductoService productoService;
    
    @SuppressWarnings("unchecked")
    private List<ItemCarrito> obtenerCarrito(HttpSession session) {
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
            session.setAttribute("carrito", carrito);
        }
        return carrito;
    }
    
    @PostMapping("/agregar/{id}")
    public String agregarAlCarrito(@PathVariable Long id, 
                                 @RequestParam(defaultValue = "1") int cantidad,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        
        Optional<Producto> productoOpt = productoService.obtenerPorId(id);
        if (productoOpt.isEmpty() || !productoOpt.get().getDisponible()) {
            redirectAttributes.addFlashAttribute("error", "Producto no disponible");
            return "redirect:/menu";
        }
        
        List<ItemCarrito> carrito = obtenerCarrito(session);
        Producto producto = productoOpt.get();
        
        // Verificar si el producto ya está en el carrito
        boolean encontrado = false;
        for (ItemCarrito item : carrito) {
            if (item.getProducto().getId().equals(id)) {
                item.setCantidad(item.getCantidad() + cantidad);
                encontrado = true;
                break;
            }
        }
        
        if (!encontrado) {
            carrito.add(new ItemCarrito(producto, cantidad));
        }
        
        session.setAttribute("carrito", carrito);
        redirectAttributes.addFlashAttribute("success", 
            producto.getNombre() + " agregado al carrito");
        
        return "redirect:/menu";
    }
    
    @GetMapping
    public String verCarrito(HttpSession session, Model model) {
        List<ItemCarrito> carrito = obtenerCarrito(session);
        BigDecimal total = carrito.stream()
            .map(ItemCarrito::getSubtotal)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        model.addAttribute("carrito", carrito);
        model.addAttribute("total", total);
        model.addAttribute("titulo", "Mi Carrito");
        return "carrito";
    }
    
    @PostMapping("/actualizar/{id}")
    public String actualizarCantidad(@PathVariable Long id,
                                   @RequestParam int cantidad,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        
        List<ItemCarrito> carrito = obtenerCarrito(session);
        
        if (cantidad <= 0) {
            // Eliminar el producto si la cantidad es 0 o negativa
            carrito.removeIf(item -> item.getProducto().getId().equals(id));
            redirectAttributes.addFlashAttribute("success", "Producto eliminado del carrito");
        } else {
            // Actualizar cantidad
            for (ItemCarrito item : carrito) {
                if (item.getProducto().getId().equals(id)) {
                    item.setCantidad(cantidad);
                    break;
                }
            }
            redirectAttributes.addFlashAttribute("success", "Cantidad actualizada");
        }
        
        session.setAttribute("carrito", carrito);
        return "redirect:/carrito";
    }
    
    @GetMapping("/eliminar/{id}")
    public String eliminarDelCarrito(@PathVariable Long id,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        
        List<ItemCarrito> carrito = obtenerCarrito(session);
        carrito.removeIf(item -> item.getProducto().getId().equals(id));
        session.setAttribute("carrito", carrito);
        
        redirectAttributes.addFlashAttribute("success", "Producto eliminado del carrito");
        return "redirect:/carrito";
    }
    
    @GetMapping("/vaciar")
    public String vaciarCarrito(HttpSession session, RedirectAttributes redirectAttributes) {
        session.removeAttribute("carrito");
        redirectAttributes.addFlashAttribute("success", "Carrito vaciado");
        return "redirect:/carrito";
    }
    
    @GetMapping("/checkout")
    public String checkout(HttpSession session, Model model) {
        List<ItemCarrito> carrito = obtenerCarrito(session);
        if (carrito.isEmpty()) {
            return "redirect:/carrito";
        }
        
        BigDecimal total = carrito.stream()
            .map(ItemCarrito::getSubtotal)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        model.addAttribute("carrito", carrito);
        model.addAttribute("total", total);
        model.addAttribute("titulo", "Confirmar Pedido");
        return "checkout";
    }
    
    @PostMapping("/confirmar")
    public String confirmarPedido(HttpSession session, RedirectAttributes redirectAttributes) {
        List<ItemCarrito> carrito = obtenerCarrito(session);
        if (carrito.isEmpty()) {
            return "redirect:/carrito";
        }
        
        // Aquí podrías guardar el pedido en la base de datos
        BigDecimal total = carrito.stream()
            .map(ItemCarrito::getSubtotal)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        // Vaciar carrito después de confirmar
        session.removeAttribute("carrito");
        
        redirectAttributes.addFlashAttribute("success", 
            "¡Pedido confirmado! Total: $" + total + ". ¡Gracias por tu compra!");
        
        return "redirect:/menu";
    }
    
}
