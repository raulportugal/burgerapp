package com.burgerapp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.burgerapp.service.ProductoService;

@Controller
public class MenuController {
    @Autowired
    private ProductoService productoService;
    
    @GetMapping({"", "/", "/menu"})
    public String mostrarMenu(Model model) {
        model.addAttribute("productos", productoService.obtenerDisponibles());
        model.addAttribute("categorias", productoService.obtenerCategorias());
        model.addAttribute("titulo", "Menú de Hamburguesas");
        return "menu";
    }
    
    @GetMapping("/menu/{categoria}")
    public String mostrarMenuPorCategoria(@PathVariable String categoria, Model model) {
        model.addAttribute("productos", productoService.obtenerPorCategoria(categoria));
        model.addAttribute("categorias", productoService.obtenerCategorias());
        model.addAttribute("categoriaSeleccionada", categoria);
        model.addAttribute("titulo", "Menú - " + categoria);
        return "menu";
    }

}
