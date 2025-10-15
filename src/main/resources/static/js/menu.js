function filtrarCategoria(nombreCategoria) {
  const productos = document.querySelectorAll(".producto-lista");
  productos.forEach((p) => {
    const cat = p.getAttribute("data-categoria");
    p.style.display =
      nombreCategoria === "todas" || cat === nombreCategoria ? "flex" : "none";
  });

  const botones = document.querySelectorAll(".categoria-filtros button");
  botones.forEach((b) => b.classList.remove("active"));
  document
    .querySelector(`[data-filtro='${nombreCategoria}']`)
    .classList.add("active");
}

document.addEventListener("DOMContentLoaded", () => {
  const botones = document.querySelectorAll(".categoria-filtros button");
  botones.forEach((boton) => {
    boton.addEventListener("click", () => {
      filtrarCategoria(boton.getAttribute("data-filtro"));
    });
  });
});
