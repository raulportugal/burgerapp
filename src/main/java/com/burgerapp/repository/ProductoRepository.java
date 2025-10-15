package com.burgerapp.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.burgerapp.model.Producto;

public interface ProductoRepository extends JpaRepository<Producto, Long> {
    List<Producto> findByCategoria(String categoria);
    List<Producto> findByDisponibleTrue();
    List<Producto> findByCategoriaAndDisponibleTrue(String categoria);
    
    @Query("SELECT DISTINCT p.categoria FROM Producto p WHERE p.disponible = true")
    List<String> findDistinctCategorias();
}
