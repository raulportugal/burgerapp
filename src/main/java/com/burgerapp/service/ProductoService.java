package com.burgerapp.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.burgerapp.model.Producto;
import com.burgerapp.repository.ProductoRepository;

@Service
public class ProductoService {
     @Autowired
    private ProductoRepository productoRepository;
    
    public List<Producto> obtenerTodos() {
        return productoRepository.findAll();
    }
    
    public List<Producto> obtenerDisponibles() {
        return productoRepository.findByDisponibleTrue();
    }
    
    public List<Producto> obtenerPorCategoria(String categoria) {
        return productoRepository.findByCategoriaAndDisponibleTrue(categoria);
    }
    
    public List<String> obtenerCategorias() {
        return productoRepository.findDistinctCategorias();
    }
    
    public Optional<Producto> obtenerPorId(Long id) {
        return productoRepository.findById(id);
    }
    
    public Producto guardar(Producto producto) {
        return productoRepository.save(producto);
    }
    
    public void eliminar(Long id) {
        productoRepository.deleteById(id);
    }
}
