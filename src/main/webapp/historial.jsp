<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    //PARA EXPORTAR JAVA
    if ("true".equals(request.getParameter("exportar"))) {
        //ISO-8859-1->idioma nativo Excel 
        response.setContentType("text/csv; charset=ISO-8859-1");
        response.setHeader("Content-Disposition", "attachment; filename=\"Reporte_Ventas_Cine.csv\"");
        
        //Cabeceras
        out.print("NRO BOLETA;FECHA Y HORA;CAJERO;TOTAL PAGADO;ESTADO\n");
        //////
        try (Connection c = new com.confiteria.dao.YGestorBaseDatos().getConnection();
                PreparedStatement p = c.prepareStatement("SELECT v.id_venta, v.fecha, v.total, per.nombre_completo FROM Venta v INNER JOIN Personal per ON v.id_personal = per.id_personal ORDER BY v.id_venta ASC");
                ResultSet r = p.executeQuery()) {
             
            while(r.next()) {
                String boleta = String.format("#%05d", r.getInt("id_venta"));
                String fecha = r.getString("fecha");
                if(fecha != null && fecha.length() > 16) fecha = fecha.substring(0, 16);
                String cajero = r.getString("nombre_completo");
                String total = String.format("%.2f", r.getDouble("total")).replace(",", ".");
                
                //Imprimir por fila
                out.print(boleta + ";" + fecha + ";" + cajero + ";" + total + ";Completado\n");
            }
        } catch(Exception e) {
            out.print("Error al generar reporte: " + e.getMessage());
        }
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Ventas | Cine Sistema</title>
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
        .page-title { font-weight: 900; color: #111827; margin-bottom: 25px; font-size: 1.8rem; letter-spacing: -0.5px; }

        .table-container { background: white; border-radius: 16px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.02); }
        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .table-title { font-weight: 800; font-size: 1.2rem; color: #111827; margin: 0; display: flex; align-items: center; gap: 10px; }
        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .custom-table th { background-color: #f9fafb; color: #6b7280; font-size: 0.75rem; font-weight: 700; padding: 15px; text-transform: uppercase; letter-spacing: 0.5px; text-align: center; }
        .custom-table td { padding: 18px 15px; vertical-align: middle; text-align: center; border-bottom: 1px solid #f3f4f6; color: #374151; font-weight: 500; font-size: 0.95rem; }
        .badge-success { background-color: #dcfce7; color: #15803d; padding: 6px 16px; border-radius: 20px; font-weight: 700; font-size: 0.8rem; }
        .btn-detail { background-color: white; border: 1px solid #e5e7eb; color: #374151; font-size: 0.85rem; font-weight: 600; padding: 6px 16px; border-radius: 6px; transition: 0.2s; }
        .btn-detail:hover { background-color: #f9fafb; border-color: #d1d5db; }
        .price-text { color: var(--cine-red); font-weight: 800; }
        .boleta-text { font-weight: 800; color: #111827; }
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
            <a href="historial.jsp" class="nav-item active"><i class="fa-solid fa-receipt"></i> Historial de Ventas</a>
            <a href="inventario.jsp" class="nav-item"><i class="fa-solid fa-box-open"></i> Inventario</a>
            <a href="personal.jsp" class="nav-item"><i class="fa-solid fa-user-group"></i> Personal</a>
            <a href="<%=request.getContextPath()%>/HistorialBoletosServlet" class="nav-item"><i class="fa-solid fa-ticket"></i> Historial Boletos</a>
        </nav>
        <div class="logout-box mt-auto">
            <a href="login.jsp" class="logout-link"><i class="fa-solid fa-arrow-right-from-bracket"></i> Cerrar Sesión</a>
        </div>
    </div>

    <div class="main-wrapper">
        <h2 class="page-title">Registro de Transacciones</h2>

        <div class="table-container">
            <div class="table-header">
                <h3 class="table-title"><i class="fa-solid fa-database text-danger" style="font-size: 1.1rem;"></i> Base de Datos de Ventas</h3>
                <div class="d-flex flex-wrap justify-content-end align-items-center gap-3">
    
    <form action="historial.jsp" method="GET" class="d-flex align-items-center m-0 shadow-sm" style="border-radius: 6px;">
        <input type="date" name="fecha_especifica" class="form-control form-control-sm border-end-0" style="border-radius: 6px 0 0 6px;" required>
        <button type="submit" class="btn btn-sm btn-dark" style="border-radius: 0 6px 6px 0;" title="Buscar fecha">
            <i class="fa-solid fa-magnifying-glass"></i>
        </button>
    </form>

    <div class="d-flex align-items-center gap-2">
        <a href="historial.jsp?filtro=hoy" class="btn btn-sm btn-outline-secondary bg-white shadow-sm"><i class="fa-solid fa-filter me-1"></i> Hoy</a>
        <a href="historial.jsp" class="btn btn-sm btn-light border shadow-sm"><i class="fa-solid fa-list"></i> Todas</a>
        <a href="historial.jsp?exportar=true" class="btn btn-sm btn-light border shadow-sm"><i class="fa-solid fa-download"></i> Exportar</a>
    </div>

</div>
            </div>
            
            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>Nº BOLETA</th>
                            <th>FECHA Y HORA (REAL)</th>
                            <th>CAJERO</th>
                            <th>TOTAL PAGADO</th>
                            <th>ESTADO</th>
                            <th>ACCIÓN</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            
                            
                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;
                            
                            try {
                                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                                conn = new com.confiteria.dao.YGestorBaseDatos().getConnection();
                                
                                //ventas->tabla venta con Personal 
                                String filtro = request.getParameter("filtro");
                                String fechaEspecifica = request.getParameter("fecha_especifica"); // Capturamos la nueva fecha

                                String sql = "SELECT v.id_venta, v.fecha, v.total, p.nombre_completo " +
                                  "FROM Venta v INNER JOIN Personal p ON v.id_personal = p.id_personal ";

                                //filtro 
                                if ("hoy".equals(filtro)) {
                                    sql += "WHERE CAST(v.fecha as DATE) = CAST(GETDATE() as DATE) ";
                                } else if (fechaEspecifica != null && !fechaEspecifica.trim().isEmpty()) {
                                // Si el usuario eligió una fecha en el calendario
                                 sql += "WHERE CAST(v.fecha as DATE) = ? ";
                                }

                                sql += "ORDER BY v.id_venta ASC";
                                ps = conn.prepareStatement(sql);

                                //fecha
                                if (fechaEspecifica != null && !fechaEspecifica.trim().isEmpty() && !"hoy".equals(filtro)) {
                                    ps.setString(1, fechaEspecifica); 
                                }

                                rs = ps.executeQuery();
                                
                                while(rs.next()) {
                                    int idVenta = rs.getInt("id_venta");
                                    String fecha = rs.getString("fecha"); 
                                    if(fecha != null && fecha.length() > 16) fecha = fecha.substring(0, 16); // Quitamos los milisegundos
                                    
                                    double total = rs.getDouble("total");
                                    String cajero = rs.getString("nombre_completo");
                                    
                                    //id #00001
                                    String nroBoleta = String.format("%05d", idVenta);
                                    
                                    //filas en html 
                                    StringBuilder filasHtml = new StringBuilder();
                                    PreparedStatement psDet = conn.prepareStatement("SELECT pr.nombre, dv.cantidad, dv.subtotal FROM DetalleVenta dv JOIN Producto pr ON dv.id_producto = pr.id_producto WHERE dv.id_venta = ?");
                                    psDet.setInt(1, idVenta);
                                    ResultSet rsDet = psDet.executeQuery();
                                    
                                    while(rsDet.next()){
                                        String nombreProd = rsDet.getString("nombre");
                                        int cant = rsDet.getInt("cantidad");
                                        double subtotal = rsDet.getDouble("subtotal");
                                        
                                        //las filas 
                                        filasHtml.append("<tr>")
                                                 .append("<td class='text-start fw-bold' style='color: #374151;'>").append(nombreProd).append("</td>")
                                                 .append("<td class='fw-bold text-muted'>").append(cant).append("</td>")
                                                 .append("<td class='text-end fw-bold' style='color: #111827;'>S/ ").append(String.format("%.2f", subtotal).replace(",", ".")).append("</td>")
                                                 .append("</tr>");
                                    }
                                    rsDet.close();
                                    psDet.close();
                        %>
                        <tr>
                            <td class="boleta-text">#<%= nroBoleta %></td>
                            <td><%= fecha %></td>
                            <td><%= cajero %></td>
                            <td class="price-text">S/ <%= String.format("%.2f", total) %></td>
                            <td><span class="badge-success">Completado</span></td>
                            <td>
                                <template id="filas-<%= nroBoleta %>">
                                    <%= filasHtml.toString() %>
                                </template>
                                
                                <button class="btn-detail" data-bs-toggle="modal" data-bs-target="#modalDetalle" 
                                    onclick="cargarDetalle('<%= nroBoleta %>', '<%= cajero %>', '<%= String.format("%.2f", total).replace(",", ".") %>', '<%= fecha %>')">
                                    <i class="fa-solid fa-eye me-1"></i> Ver Detalle
                                </button>
                            </td>
                        </tr>
                        <%
                                }
                            } catch(Exception e) {
                                out.print("<tr><td colspan='6' class='text-danger'>Error de Base de Datos: " + e.getMessage() + "</td></tr>");
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

    <div class="modal fade" id="modalDetalle" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="border-radius: 16px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.2);">
                <div class="modal-header border-bottom" style="background-color: #f8f9fa; border-radius: 16px 16px 0 0;">
                    <h5 class="modal-title fw-bold" style="color: #111827;">
                        <i class="fa-solid fa-receipt me-2 text-danger"></i> Detalle de Boleta <span id="modal-boleta-id" class="text-danger"></span>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <p class="text-muted mb-3" style="font-size: 0.9rem;">
                        <strong>Atendido por:</strong> <span id="modal-cajero" class="text-dark fw-bold"></span> <br>
                        <strong>Fecha:</strong> <span id="modal-fecha" class="text-dark fw-bold"></span>
                    </p>
                    <div class="table-responsive mt-3">
                        <table class="table table-sm text-center align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th class="text-start" style="color: #6b7280; font-size: 0.8rem;">PRODUCTO</th>
                                    <th style="color: #6b7280; font-size: 0.8rem;">CANT.</th>
                                    <th class="text-end" style="color: #6b7280; font-size: 0.8rem;">SUBTOTAL</th>
                                </tr>
                            </thead>
                            <tbody id="modal-tbody">
                                </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer d-flex justify-content-between align-items-center" style="background-color: #f8f9fa; border-radius: 0 0 16px 16px;">
                    <span class="fs-5 fw-bold text-dark">TOTAL:</span>
                    <span class="fs-4 fw-bold text-danger">S/ <span id="modal-total"></span></span>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function cargarDetalle(nroBoleta, cajero, total, fecha) {
            // Llenar cabecera
            document.getElementById('modal-boleta-id').innerText = "#" + nroBoleta;
            document.getElementById('modal-cajero').innerText = cajero;
            document.getElementById('modal-total').innerText = total;
            document.getElementById('modal-fecha').innerText = fecha;
            
            // Copiar las filas 
            const filasOcultas = document.getElementById('filas-' + nroBoleta).innerHTML;
            document.getElementById('modal-tbody').innerHTML = filasOcultas;
        }
        
        
    </script>
</body>
</html>