<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario | Cine Sistema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --cine-red: #e50914; --cine-dark: #1b1b1b; --cine-gray: #f4f6f9; }
        body { background-color: var(--cine-gray); font-family: 'Segoe UI', sans-serif; }
        
        /* Sidebar Exacto */
        .sidebar { width: 260px; background-color: var(--cine-dark); height: 100vh; position: fixed; left: 0; top: 0; display: flex; flex-direction: column; padding-top: 25px; }
        .brand-logo { padding: 0 25px 25px; font-size: 1.25rem; font-weight: 800; color: white; display: flex; align-items: center; gap: 10px; }
        .user-box { background-color: #242424; margin: 0 20px 30px; padding: 15px; border-radius: 12px; display: flex; align-items: center; gap: 15px; }
        .user-avatar { width: 42px; height: 42px; background-color: var(--cine-red); color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; border-radius: 8px; font-size: 1.1rem; }
        .user-info { display: flex; flex-direction: column; }
        .user-name { color: white; font-weight: 700; font-size: 0.95rem; line-height: 1.2; }
        .user-status { color: #28a745; font-size: 0.75rem; display: flex; align-items: center; gap: 6px; margin-top: 3px; }
        .status-dot { width: 8px; height: 8px; background-color: #28a745; border-radius: 50%; box-shadow: 0 0 5px rgba(40, 167, 69, 0.5); }
        .nav-menu { list-style: none; padding: 0 20px; margin: 0; flex-grow: 1; }
        .nav-item { padding: 12px 20px; display: flex; align-items: center; gap: 15px; color: #9ca3af; text-decoration: none; border-radius: 10px; margin-bottom: 8px; font-weight: 500; font-size: 0.95rem; transition: 0.2s; }
        .nav-item:hover { color: white; background-color: rgba(255,255,255,0.05); }
        .nav-item.active { background-color: var(--cine-red); color: white; font-weight: 600; box-shadow: 0 4px 12px rgba(229, 9, 20, 0.2); }
        .logout-box { margin: 20px; padding: 15px; background-color: #2a1b1c; border-radius: 10px; text-align: center; }
        .logout-link { color: var(--cine-red); text-decoration: none; font-weight: 600; display: flex; align-items: center; justify-content: center; gap: 10px; font-size: 0.95rem; }
        
        .main-wrapper { margin-left: 260px; padding: 35px 40px; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .page-title { font-weight: 900; color: #111827; margin: 0; font-size: 1.8rem; letter-spacing: -0.5px; }
        .btn-add-product { background-color: var(--cine-red); color: white; font-weight: 600; padding: 10px 20px; border-radius: 10px; border: none; box-shadow: 0 4px 12px rgba(229, 9, 20, 0.2); transition: 0.2s; }
        .btn-add-product:hover { background-color: #c20710; color: white; }

        .table-container { background: white; border-radius: 16px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.02); }
        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .custom-table th { background-color: #f9fafb; color: #6b7280; font-size: 0.75rem; font-weight: 700; padding: 15px; text-transform: uppercase; letter-spacing: 0.5px; text-align: center; }
        .custom-table td { padding: 18px 15px; vertical-align: middle; text-align: center; border-bottom: 1px solid #f3f4f6; color: #374151; font-weight: 500; font-size: 0.95rem; }
        
        /* Badges de Stock dinámicos */
        .badge-stock-normal { background-color: #dcfce7; color: #15803d; padding: 6px 14px; border-radius: 20px; font-weight: 700; font-size: 0.8rem; }
        .badge-stock-low { background-color: #fee2e2; color: #ef4444; padding: 6px 14px; border-radius: 20px; font-weight: 700; font-size: 0.8rem; }
        
        /* Botones de acción redondeados */
        .action-btn-group { display: flex; justify-content: center; gap: 8px; }
        .btn-action { width: 34px; height: 34px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 0.9rem; transition: 0.2s; background-color: white; border: 1px solid #e5e7eb; }
        .btn-action-edit { color: #0ea5e9; }
        .btn-action-edit:hover { background-color: #e0f2fe; border-color: #0ea5e9; }
        .btn-action-stock { color: #f59e0b; }
        .btn-action-stock:hover { background-color: #fef3c7; border-color: #f59e0b; }
        .btn-action-delete { color: #ef4444; }
        .btn-action-delete:hover { background-color: #fee2e2; border-color: #ef4444; }
        
        .price-text { font-weight: 700; color: #111827; }
        .prod-id-text { font-weight: 800; color: #9ca3af; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="brand-logo"><i class="fa-solid fa-clapperboard text-danger"></i> CINE SISTEMA</div>
        <div class="user-box">
            <div class="user-avatar">AG</div>
            <div class="user-info">
                <span class="user-name">${usuarioLogueado != null ? usuarioLogueado.nombreCompleto : 'Ana Gomez'}</span>
                <span class="user-status"><div class="status-dot"></div> Online</span>
            </div>
        </div>
        <nav class="nav-menu">
            <a href="inicio.jsp" class="nav-item"><i class="fa-solid fa-chart-pie"></i> Dashboard</a>
            <a href="historial.jsp" class="nav-item"><i class="fa-solid fa-receipt"></i> Historial de Ventas</a>
            <a href="inventario.jsp" class="nav-item active"><i class="fa-solid fa-box-open"></i> Inventario</a>
            <a href="personal.jsp" class="nav-item"><i class="fa-solid fa-user-group"></i> Personal</a>
            <a href="<%=request.getContextPath()%>/HistorialBoletosServlet" class="nav-item"><i class="fa-solid fa-ticket"></i> Historial Boletos</a>
        </nav>
        <div class="logout-box mt-auto">
            <a href="login.jsp" class="logout-link"><i class="fa-solid fa-arrow-right-from-bracket"></i> Cerrar Sesión</a>
        </div>
    </div>

    <div class="main-wrapper">
        <div class="page-header">
            <h2 class="page-title">Control de Inventario</h2>
            <button class="btn-add-product" data-bs-toggle="modal" data-bs-target="#modalNuevo">
                <i class="fa-solid fa-plus me-2"></i> Nuevo Producto
            </button>
        </div>

        <div class="table-container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold text-dark m-0"><i class="fa-solid fa-list text-danger me-2"></i> Lista de Almacén</h5>
                <div class="input-group" style="width: 320px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); border-radius: 8px;">
                    <span class="input-group-text bg-white border-end-0" style="border-radius: 8px 0 0 8px;"><i class="fa-solid fa-magnifying-glass text-muted"></i></span>
                    <input type="text" id="buscadorInventario" class="form-control border-start-0" placeholder="Buscar por nombre..." style="border-radius: 0 8px 8px 0; font-size: 0.95rem;">
                </div>
            </div>
            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>NOMBRE DEL PRODUCTO</th>
                            <th>PRECIO VENTA</th>
                            <th>STOCK ACTUAL</th>
                            <th>ESTADO STOCK</th>
                            <th>ACCIONES</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;

                            try {
                                conn = new com.confiteria.dao.YGestorBaseDatos().getConnection();
                                
                                String sql = "SELECT id_producto, nombre, precio, stock FROM Producto ORDER BY id_producto ASC";
                                ps = conn.prepareStatement(sql);
                                rs = ps.executeQuery();
                                
                                while(rs.next()) {
                                    int id = rs.getInt("id_producto");
                                    String nombre = rs.getString("nombre");
                                    double precio = rs.getDouble("precio");
                                    int stock = rs.getInt("stock");
                                    
                                    // Evaluamos visualmente si el stock es bajo (< 15)
                                    String claseBadge = (stock < 15) ? "badge-stock-low" : "badge-stock-normal";
                                    String textoEstado = (stock < 15) ? "Stock Bajo" : "Disponible";
                        %>
                        <tr>
                            <td class="prod-id-text">#<%= String.format("%03d", id) %></td>
                            <td class="text-start fw-bold text-dark" style="padding-left: 25px;"><%= nombre %></td>
                            <td class="price-text">S/ <%= String.format("%.2f", precio) %></td>
                            <td class="fw-bold fs-5"><%= stock %></td>
                            <td><span class="<%= claseBadge %>"><%= textoEstado %></span></td>
                            <td>
                                <div class="action-btn-group">
                                    <button class="btn-action btn-action-edit" title="Editar Producto"
                                        onclick="abrirEditar(<%= id %>, '<%= nombre.replace("'", "\\'") %>', <%= precio %>)">
                                        <i class="fa-solid fa-pen"></i>
                                    </button>
                                    <button class="btn-action btn-action-stock" title="Reponer Inventario"
                                        onclick="abrirReponer(<%= id %>, '<%= nombre.replace("'", "\\'") %>', <%= stock %>)">
                                        <i class="fa-solid fa-box"></i>
                                    </button>
                                    <button class="btn-action btn-action-delete" title="Eliminar Producto"
                                        onclick="confirmarEliminar(<%= id %>, '<%= nombre.replace("'", "\\'") %>')">
                                        <i class="fa-solid fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <%
                                }
                            } catch(Exception e) {
                                out.print("<tr><td colspan='6' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                            } finally {
                                try { if(rs != null) rs.close(); } catch(Exception e) {}
                                try { if(ps != null) ps.close(); } catch(Exception e) {}
                                try { if(conn != null) conn.close(); } catch(Exception e) {}
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalNuevo" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 16px; border: none;">
                <div class="modal-header border-bottom bg-light" style="border-radius: 16px 16px 0 0;">
                    <h5 class="modal-title fw-bold text-dark"><i class="fa-solid fa-plus text-danger me-2"></i> Registrar Nuevo Producto</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="InventarioServlet" method="POST">
                    <input type="hidden" name="accion" value="crear">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Nombre del Producto</label>
                            <input type="text" name="nombre" class="form-control" placeholder="Ej. Combo Popcorn Gigante" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Precio (S/)</label>
                                <input type="number" step="0.10" name="precio" class="form-control" placeholder="15.50" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Stock Inicial</label>
                                <input type="number" name="stock" class="form-control" placeholder="50" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light" style="border-radius: 0 0 16px 16px;">
                        <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-danger fw-bold px-4">Guardar Producto</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalEditar" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 16px; border: none;">
                <div class="modal-header border-bottom bg-light" style="border-radius: 16px 16px 0 0;">
                    <h5 class="modal-title fw-bold text-dark"><i class="fa-solid fa-pen text-info me-2"></i> Editar Datos</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="InventarioServlet" method="POST">
                    <input type="hidden" name="accion" value="editar">
                    <input type="hidden" name="id" id="edit-id">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Nombre del Producto</label>
                            <input type="text" name="nombre" id="edit-nombre" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Precio de Venta (S/)</label>
                            <input type="number" step="0.10" name="precio" id="edit-precio" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer bg-light" style="border-radius: 0 0 16px 16px;">
                        <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-info text-white fw-bold px-4">Actualizar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalStock" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 16px; border: none;">
                <div class="modal-header border-bottom bg-light" style="border-radius: 16px 16px 0 0;">
                    <h5 class="modal-title fw-bold text-dark"><i class="fa-solid fa-box text-warning me-2"></i> Reponer Stock</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="InventarioServlet" method="POST">
                    <input type="hidden" name="accion" value="reponer">
                    <input type="hidden" name="id" id="stock-id">
                    <div class="modal-body p-4 text-center">
                        <h4 class="fw-bold mb-1 text-dark" id="stock-nombre"></h4>
                        <p class="text-muted">Stock actual en almacén: <span class="fw-bold text-dark fs-5" id="stock-actual"></span> unidades.</p>
                        <div class="mx-auto mt-4" style="max-width: 250px;">
                            <label class="form-label fw-bold text-danger">¿CUÁNTAS UNIDADES INGRESAN?</label>
                            <input type="number" name="cantidad_nueva" class="form-control form-control-lg text-center fw-bold text-primary" placeholder="0" min="1" required>
                        </div>
                    </div>
                    <div class="modal-footer bg-light" style="border-radius: 0 0 16px 16px;">
                        <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-warning fw-bold px-4">Agregar al Almacén</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        //Alertas
        document.addEventListener("DOMContentLoaded", function() {
            const urlParams = new URLSearchParams(window.location.search);
            const success = urlParams.get('success');
            const error = urlParams.get('error');

            if (success) {
                let titulo = "¡Operación Exitosa!";
                let texto = "El inventario ha sido actualizado correctamente.";

                // Filtros analíticos para personalizar cada botón
                if (success === 'crear') {
                    titulo = "¡Producto Registrado!";
                    texto = "El nuevo producto ha sido guardado correctamente en el almacén.";
                } else if (success === 'editar') {
                    titulo = "¡Producto Modificado!";
                    texto = "Los datos del producto han sido editados y guardados con éxito.";
                } else if (success === 'reponer') {
                    titulo = "¡Stock Actualizado!";
                    texto = "Las nuevas unidades se han sumado correctamente al inventario.";
                } else if (success === 'eliminar') {
                    titulo = "¡Producto Eliminado!";
                    texto = "El artículo ha sido retirado del catálogo de almacén.";
                }

                Swal.fire({
                    icon: 'success',
                    iconColor: '#28a745',
                    title: titulo,
                    text: texto,
                    confirmButtonColor: '#e50914'
                }).then(() => {
                    window.history.replaceState(null, null, window.location.pathname);
                });
                
            } else if (error === 'restriccion') {
                Swal.fire({
                    icon: 'warning',
                    title: 'Acción Bloqueada',
                    text: 'No se puede eliminar este producto porque ya tiene ventas registradas en el historial.',
                    confirmButtonColor: '#e50914'
                }).then(() => {
                    window.history.replaceState(null, null, window.location.pathname);
                });
            } else if (error === '1') {
                Swal.fire({
                    icon: 'error',
                    title: 'Error del Sistema',
                    text: 'Ocurrió un problema en la base de datos al procesar la solicitud.',
                    confirmButtonColor: '#e50914'
                }).then(() => {
                    window.history.replaceState(null, null, window.location.pathname);
                });
            }
        });

        // editar, reponer
        const modalEdit = new bootstrap.Modal(document.getElementById('modalEditar'));
        const modalStock = new bootstrap.Modal(document.getElementById('modalStock'));

        function abrirEditar(id, nombre, precio) {
            document.getElementById('edit-id').value = id;
            document.getElementById('edit-nombre').value = nombre;
            document.getElementById('edit-precio').value = precio;
            modalEdit.show();
        }

        function abrirReponer(id, nombre, stockActual) {
            document.getElementById('stock-id').value = id;
            document.getElementById('stock-nombre').innerText = nombre;
            document.getElementById('stock-actual').innerText = stockActual;
            modalStock.show();
        }

        //eliminar
        function confirmarEliminar(id, nombre) {
            Swal.fire({
                title: '¿Eliminar producto?',
                text: "Estás a punto de eliminar '" + nombre + "' del sistema.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#e50914',
                cancelButtonColor: '#6b7280',
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = "InventarioServlet?accion=eliminar&id=" + id;
                }
            });
        }
        
        //buscador
        document.getElementById('buscadorInventario').addEventListener('keyup', function() {
            let textoBusqueda = this.value.toLowerCase();
            let filas = document.querySelectorAll('.custom-table tbody tr');

            filas.forEach(function(fila) {
                let nombreProducto = fila.cells[1].textContent.toLowerCase();
                if (nombreProducto.includes(textoBusqueda)) {
                    fila.style.display = ''; 
                } else {
                    fila.style.display = 'none'; 
                }
            });
        });
    </script>
</body>
</html>