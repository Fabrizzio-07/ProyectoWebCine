<%@page import="com.confiteria.modelo.YProducto"%>
<%@page import="java.util.List"%>
<%@page import="com.confiteria.dao.YGestorProducto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Ventas | Cine Sistema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --cine-red: #e50914;
            --cine-dark: #121212;
            --cine-gray: #f0f2f5;
        }
        body { background-color: var(--cine-gray); font-family: 'Segoe UI', sans-serif; margin: 0; overflow-x: hidden; }
        .sidebar { width: 240px; background-color: var(--cine-dark); height: 100vh; position: fixed; left: 0; top: 0; color: white; padding: 20px 0; display: flex; flex-direction: column; }
        .brand-logo { padding: 0 20px 30px; font-size: 1.25rem; font-weight: bold; }
        .user-info { padding: 0 20px 30px; display: flex; align-items: center; gap: 12px; }
        .user-info img { width: 45px; height: 45px; border-radius: 8px; object-fit: cover; }
        .nav-menu { list-style: none; padding: 0; margin: 0; flex-grow: 1; }
        .nav-item { padding: 12px 20px; display: flex; align-items: center; gap: 15px; color: #aaa; text-decoration: none; transition: 0.3s; border-left: 4px solid transparent; }
        .nav-item:hover, .nav-item.active { background-color: #1e1e1e; color: white; border-left-color: var(--cine-red); }
        .logout-item { padding: 20px; color: var(--cine-red); text-decoration: none; border-top: 1px solid #222; }
        .main-wrapper { margin-left: 240px; margin-right: 380px; padding: 20px; }
        .search-container { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; background: white; padding: 10px 20px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .search-box { display: flex; flex-grow: 1; max-width: 500px; }
        .search-box input { border: 1px solid #ddd; border-right: none; border-radius: 8px 0 0 8px; padding: 8px 15px; width: 100%; outline: none; }
        .search-box button { background: var(--cine-red); color: white; border: none; padding: 0 20px; border-radius: 0 8px 8px 0; }
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; }
        .product-card { background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); transition: 0.3s; }
        .product-card:hover { transform: translateY(-5px); }
        .product-img { width: 100%; height: 160px; object-fit: cover; background: #eee; }
        .product-info { padding: 15px; }
        .product-name { font-weight: bold; font-size: 1rem; margin-bottom: 5px; color: #333; height: 44px; overflow: hidden; }
        .product-price { color: var(--cine-red); font-weight: 800; font-size: 1.1rem; }
        .product-stock { font-size: 0.85rem; color: #888; margin-bottom: 15px; }
        .btn-add { width: 100%; background: #f0f0f0; border: none; padding: 8px; border-radius: 8px; font-weight: bold; transition: 0.3s; }
        .btn-add:hover { background: var(--cine-dark); color: white; }
        .cart-panel { width: 380px; background: white; height: 100vh; position: fixed; right: 0; top: 0; box-shadow: -5px 0 20px rgba(0,0,0,0.05); padding: 25px; display: flex; flex-direction: column; }
        .cart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .cart-items { flex-grow: 1; overflow-y: auto; }
        .cart-item { display: flex; align-items: center; gap: 10px; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid #f0f0f0; }
        .cart-item-img { width: 50px; height: 50px; border-radius: 8px; object-fit: cover; }
        .cart-item-detail { flex-grow: 1; }
        .cart-item-name { font-weight: bold; font-size: 0.9rem; }
        .cart-item-price { font-size: 0.85rem; color: #666; }
        .qty-controls { display: flex; align-items: center; gap: 8px; background: #f5f5f5; border-radius: 6px; padding: 2px 8px; }
        .qty-btn { border: none; background: none; font-weight: bold; cursor: pointer; }
        .cart-summary { padding-top: 20px; border-top: 2px solid #eee; }
        .total-row { display: flex; justify-content: space-between; margin-bottom: 25px; font-size: 1.5rem; font-weight: 800; color: var(--cine-red); }
        .btn-cobrar { background: #28a745; color: white; border: none; width: 100%; padding: 15px; border-radius: 12px; font-weight: bold; font-size: 1.2rem; display: flex; align-items: center; justify-content: center; gap: 10px; cursor: pointer; }
        .btn-cancelar { display: block; text-align: center; color: #888; text-decoration: none; margin-top: 15px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="brand-logo"><i class="fa-solid fa-clapperboard me-2 text-danger"></i> CINE SISTEMA</div>
        <div class="user-info">
            <img src="https://ui-avatars.com/api/?name=${usuarioLogueado != null ? usuarioLogueado.nombreCompleto : 'Cajero'}&background=e50914&color=fff" alt="User">
            <div>
                <div class="fw-bold" style="font-size: 0.9rem;">${usuarioLogueado != null ? usuarioLogueado.nombreCompleto : 'Cajero de Turno'}</div>
                <div style="font-size: 0.75rem; color: #777;">En línea</div>
            </div>
        </div>
            <nav class="nav-menu">
                <a href="ventas.jsp" class="nav-item active"><i class="fa-solid fa-cash-register"></i> Ventas</a>
                <a href="<%=request.getContextPath()%>/CajeroPeliculasServlet" class="nav-item">
                    <i class="fa-solid fa-ticket"></i> Boletos
                </a>
            </nav>
        <a href="login.jsp" class="logout-item"><i class="fa-solid fa-arrow-right-from-bracket me-2"></i> Cerrar Sesión</a>
    </div>

    <div class="main-wrapper">
        <div class="search-container">
            <div class="search-box">
                <input type="text" id="inputBusqueda" placeholder="Buscar producto..." onkeyup="filtrarProductos()">
                <button><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>
        </div>

        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if ("1".equals(success)) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert" id="alertaSistema" style="border-radius: 12px; font-weight: 500;">
                <i class="fa-solid fa-circle-check me-2"></i> ¡Venta cobrada y registrada con éxito! El stock ha sido actualizado.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            } else if ("1".equals(error)) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert" id="alertaSistema" style="border-radius: 12px; font-weight: 500;">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> Hubo un error al procesar el cobro. Inténtalo de nuevo.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            }
        %>
        
        <h4 class="fw-bold mb-4">Catálogo de Productos</h4>

        <div class="product-grid">
            <%
                YGestorProducto gestorProd = new YGestorProducto();
                List<YProducto> lista = gestorProd.listarProductosActivos();
                
                for(YProducto prod : lista) {
            %>
            <div class="product-card">
                <img src="<%= (prod.getImagen() != null && !prod.getImagen().isEmpty()) ? prod.getImagen() : "https://picsum.photos/400/300" %>" class="product-img">
                <div class="product-info">
                    <div class="product-name"><%= prod.getNombre() %></div>
                    <div class="product-price">S/ <%= String.format("%.2f", prod.getPrecio()) %></div>
                    <div class="product-stock" data-stock-original="<%= prod.getStock() %>">
                        Stock disponible: <span id="stock-val-<%= prod.getIdProducto() %>"><%= prod.getStock() %></span>
                    </div>
                    <button class="btn-add" id="btn-add-<%= prod.getIdProducto() %>" onclick="agregar(<%= prod.getIdProducto() %>, '<%= prod.getNombre().replace("'", "\\'") %>', <%= prod.getPrecio() %>, '<%= prod.getImagen() %>', <%= prod.getStock() %>)">
                        <i class="fa-solid fa-plus me-1"></i> Agregar
                    </button>
                </div>
            </div>
            <%
                }
            %>
        </div>
    </div>

    <div class="cart-panel">
        <div class="cart-header">
            <h5 class="fw-bold m-0"><i class="fa-solid fa-cart-shopping me-2 text-danger"></i> Venta Actual</h5>
            <button class="btn btn-sm btn-outline-secondary border-0" onclick="vaciarCarrito()">Vaciar</button>
        </div>

        <div class="cart-items" id="lista-carrito">
            <div class="text-center py-5 text-muted" id="cart-empty-msg">No hay productos seleccionados</div>
        </div>

        <div class="cart-summary">
            <div class="total-row"><span>TOTAL</span><span id="txt-total">S/ 0.00</span></div>

            <form id="formVenta" action="ProcesarVentaServlet" method="POST">
                <input type="hidden" name="datosVenta" id="datosVentaInput">
                <button type="button" class="btn-cobrar" onclick="enviarVentaAJava()">
                    <i class="fa-solid fa-money-bill-wave"></i> COBRAR
                </button>
            </form>
            <a href="#" class="btn-cancelar" onclick="vaciarCarrito()">CANCELAR VENTA</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Ocultar alerta éxito después de 4 seg
        setTimeout(() => {
            const alertaNode = document.getElementById('alertaSistema');
            if (alertaNode && typeof bootstrap !== 'undefined') {
                const alerta = new bootstrap.Alert(alertaNode);
                alerta.close();
            }
        }, 4000);

        let carrito = [];

        function agregar(id, nombre, precio, img, stockMax) {
            let index = carrito.findIndex(p => p.id === id);
            
            let cantActualEnCarrito = index !== -1 ? carrito[index].cant : 0;
            if (cantActualEnCarrito >= stockMax) {
                alert("¡Lo sentimos! No queda más stock de este producto en inventario.");
                return;
            }

            if (index !== -1) {
                carrito[index].cant++;
            } else {
                carrito.push({ id, nombre, precio, img, cant: 1, stockMax });
            }
            renderizar();
        }

        function cambiarCant(id, delta) {
            let index = carrito.findIndex(p => p.id === id);
            if (index !== -1) {
                let nuevaCant = carrito[index].cant + delta;
                
                if (delta > 0 && nuevaCant > carrito[index].stockMax) {
                    alert("No puedes agregar más unidades, superas el stock disponible.");
                    return;
                }

                carrito[index].cant = nuevaCant;
                if (carrito[index].cant <= 0) {
                    carrito.splice(index, 1);
                }
            }
            renderizar();
        }

        function vaciarCarrito() {
            carrito = [];
            renderizar();
        }

        function renderizar() {
            const container = document.getElementById('lista-carrito');
            container.innerHTML = "";
            
            document.querySelectorAll('[data-stock-original]').forEach(elemento => {
                let stockOriginal = parseInt(elemento.getAttribute('data-stock-original'));
                let spanId = elemento.querySelector('span').id;
                document.getElementById(spanId).innerText = stockOriginal;
            });

            if (carrito.length === 0) {
                container.innerHTML = `<div class="text-center py-5 text-muted" id="cart-empty-msg">No hay productos seleccionados</div>`;
                document.getElementById('txt-total').innerText = "S/ 0.00";
                return;
            }

            let total = 0;
            carrito.forEach(p => {
                let sub = p.precio * p.cant;
                total += sub;
                
                let stockRestante = p.stockMax - p.cant;
                document.getElementById("stock-val-" + p.id).innerText = stockRestante;

                let div = document.createElement('div');
                div.className = "cart-item";
                div.innerHTML = `
                    <img src="` + (p.img ? p.img : 'https://picsum.photos/50') + `" class="cart-item-img">
                    <div class="cart-item-detail">
                        <div class="cart-item-name">` + p.nombre + `</div>
                        <div class="cart-item-price">S/ ` + p.precio.toFixed(2) + `</div>
                    </div>
                    <div class="qty-controls">
                        <button class="qty-btn" onclick="cambiarCant(` + p.id + `, -1)">-</button>
                        <span>` + p.cant + `</span>
                        <button class="qty-btn" onclick="cambiarCant(` + p.id + `, 1)">+</button>
                    </div>
                    <div class="fw-bold ms-2" style="min-width:60px; text-align:right;">S/ ` + sub.toFixed(2) + `</div>
                `;
                container.appendChild(div);
            });

            document.getElementById('txt-total').innerText = "S/ " + total.toFixed(2);
        }

        function enviarVentaAJava() {
            if(carrito.length === 0) {
                alert("La boleta está vacía. Agrega productos antes de cobrar.");
                return;
            }
            document.getElementById('datosVentaInput').value = JSON.stringify(carrito);
            document.getElementById('formVenta').submit();
        }
        
        function filtrarProductos() {
            let textoBusqueda = document.getElementById('inputBusqueda').value.toLowerCase();
            let tarjetas = document.querySelectorAll('.product-card');

            tarjetas.forEach(tarjeta => {
                let nombreProducto = tarjeta.querySelector('.product-name').innerText.toLowerCase();
                
                if (nombreProducto.includes(textoBusqueda)) {
                    tarjeta.style.display = ""; 
                } else {
                    tarjeta.style.display = "none"; 
                }
            });
        }
    </script>
</body>
</html>