// menu.js - versión robusta para filtros
(function () {
  "use strict";

  function normalizeKey(s) {
    if (s == null) return "";
    return String(s).trim().toLowerCase().replace(/\s+/g, "-");
  }

  function filtrarCategoria(nombreCategoria) {
    nombreCategoria = normalizeKey(nombreCategoria);

    const productos = document.querySelectorAll(".producto-lista");
    productos.forEach((p) => {
      const cat = normalizeKey(p.getAttribute("data-categoria"));
      p.style.display = (nombreCategoria === "todas" || cat === nombreCategoria) ? "flex" : "none";
    });

    const botones = document.querySelectorAll(".categoria-filtros button");
    botones.forEach((b) => b.classList.remove("active"));

    const botonActivo = document.querySelector(`.categoria-filtros button[data-filtro='${CSS.escape(nombreCategoria)}']`);
    if (botonActivo) {
      botonActivo.classList.add("active");
    } else {
      const primero = document.querySelector(".categoria-filtros button[data-filtro='todas']");
      if (primero) primero.classList.add("active");
    }
  }

  document.addEventListener("DOMContentLoaded", () => {
    const cont = document.querySelector(".categoria-filtros");
    if (!cont) return;

    cont.addEventListener("click", (ev) => {
      const btn = ev.target.closest("button");
      if (!btn) return;
      const filtro = btn.getAttribute("data-filtro");
      filtrarCategoria(filtro || "todas");
    });

    // inicializar filtro por defecto
    const activo = document.querySelector(".categoria-filtros button.active");
    if (activo) {
      filtrarCategoria(activo.getAttribute("data-filtro") || "todas");
    } else {
      filtrarCategoria("todas");
    }
  });
})();
