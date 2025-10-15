package com.burgerapp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.burgerapp.model.Producto;
import com.burgerapp.service.ProductoService;


import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/productos")
public class ProductoController {
    @Autowired
    private ProductoService productoService;
    
    @GetMapping
    public String listarProductos(Model model) {
        List<Producto> productos = productoService.obtenerTodos();
        model.addAttribute("productos", productos);
        model.addAttribute("titulo", "Gestión de Productos");
        return "admin/productos";
    }
    
    @GetMapping("/nuevo")
    public String mostrarFormularioNuevo(Model model) {
        model.addAttribute("producto", new Producto());
        model.addAttribute("categorias", List.of("Hamburguesa", "Bebida", "Acompañamiento", "Postre"));
        model.addAttribute("titulo", "Nuevo Producto");
        return "admin/formulario-producto";
    }
    
    @PostMapping("/guardar")
    public String guardarProducto(@Validated @ModelAttribute Producto producto, 
                                BindingResult result,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        
        if (result.hasErrors()) {
            model.addAttribute("categorias", List.of("Hamburguesa", "Bebida", "Acompañamiento", "Postre"));
            model.addAttribute("titulo", producto.getId() == null ? "Nuevo Producto" : "Editar Producto");
            return "admin/formulario-producto";
        }
        
        productoService.guardar(producto);
        redirectAttributes.addFlashAttribute("success", 
            producto.getId() == null ? "Producto creado exitosamente" : "Producto actualizado exitosamente");
        
        return "redirect:/burgerapp/admin/productos";
    }
    
    @GetMapping("/editar/{id}")
    public String mostrarFormularioEditar(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<Producto> producto = productoService.obtenerPorId(id);
        
        if (producto.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Producto no encontrado");
            return "redirect:/burgerapp/admin/productos";
        }
        
        model.addAttribute("producto", producto.get());
        model.addAttribute("categorias", List.of("Hamburguesa", "Bebida", "Acompañamiento", "Postre"));
        model.addAttribute("titulo", "Editar Producto");
        return "admin/formulario-producto";
    }
    
    @GetMapping("/eliminar/{id}")
    public String eliminarProducto(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            productoService.eliminar(id);
            redirectAttributes.addFlashAttribute("success", "Producto eliminado exitosamente");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error al eliminar el producto");
        }
        return "redirect:/burgerapp/admin/productos";
    }
}
