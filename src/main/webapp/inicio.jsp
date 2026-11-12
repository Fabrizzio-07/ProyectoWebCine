<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    //para exportar
    if ("true".equals(request.getParameter("exportar"))) {
        response.setContentType("text/csv; charset=ISO-8859-1");
        response.setHeader("Content-Disposition", "attachment; filename=\"Resumen_Dashboard_Hoy.csv\"");
        /////
        try (Connection conn = new com.confiteria.dao.YGestorBaseDatos().getConnection()) {/////
            
            double dinero = 0.0;
            int unidades = 0;
            int stockBajo = 0;
            
            //Consultas excel
            try (PreparedStatement ps = conn.prepareStatement("SELECT ISNULL(SUM(total), 0) FROM Venta WHERE CONVERT(date, fecha) = CONVERT(date, GETDATE())");
                 ResultSet rs = ps.executeQuery()) { if(rs.next()) dinero = rs.getDouble(1); }
                 
            try (PreparedStatement ps = conn.prepareStatement("SELECT ISNULL(SUM(dv.cantidad), 0) FROM DetalleVenta dv INNER JOIN Venta v ON dv.id_venta = v.id_venta WHERE CONVERT(date, v.fecha) = CONVERT(date, GETDATE())");
                 ResultSet rs = ps.executeQuery()) { if(rs.next()) unidades = rs.getInt(1); }
                 
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM Producto WHERE stock < 15");
                 ResultSet rs = ps.executeQuery()) { if(rs.next()) stockBajo = rs.getInt(1); }
            
            //reporte excel
            out.print("REPORTE DE RENDIMIENTO DIARIO - CINE SISTEMA\n");
            out.print("Generado el: ;" + new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) + "\n\n");
            
            out.print("RESUMEN GENERAL DEL DIA\n");
            out.print("METRICA;VALOR\n");
            out.print("Ingresos Totales Caja;S/ " + String.format("%.2f", dinero).replace(",", ".") + "\n");
            out.print("Productos Vendidos (Unidades);" + unidades + "\n");
            out.print("Alertas de Stock Bajo (<15);" + stockBajo + "\n\n");
            
            out.print("DESGLOSE DE PRODUCTOS VENDIDOS HOY\n");
            out.print("PRODUCTO;CANTIDAD TOTAL;TOTAL INGRESOS\n");
            
            String sqlDesglose = "SELECT p.nombre, SUM(dv.cantidad) as cant, SUM(dv.subtotal) as sub " +
                                 "FROM DetalleVenta dv " +
                                 "INNER JOIN Venta v ON dv.id_venta = v.id_venta " +
                                 "INNER JOIN Producto p ON dv.id_producto = p.id_producto " +
                                 "WHERE CONVERT(date, v.fecha) = CONVERT(date, GETDATE()) " +
                                 "GROUP BY p.nombre";
                                 
            try (PreparedStatement ps = conn.prepareStatement(sqlDesglose);
                 ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    out.print(rs.getString("nombre") + ";" + rs.getInt("cant") + ";S/ " + String.format("%.2f", rs.getDouble("sub")).replace(",", ".") + "\n");
                }
            }
        } catch(Exception e) {
            out.print("Error al exportar: " + e.getMessage());
        }
        return; //Corta la ejecución 
    }

    // ========================================
    // LÓGICA PARA LAS TARJETAS DE LA PANTALLA
    // ========================================
    double ventasHoy = 0.0;
    int prodsVendidosHoy = 0;
    int alertasStockBajo = 0;
    /////
    try (Connection conn = new com.confiteria.dao.YGestorBaseDatos().getConnection()) { //////
        
        try (PreparedStatement ps1 = conn.prepareStatement("SELECT ISNULL(SUM(total), 0) FROM Venta WHERE CAST(fecha as DATE) = CAST(GETDATE() as DATE)");
             ResultSet rs1 = ps1.executeQuery()) { if(rs1.next()) ventasHoy = rs1.getDouble(1); }

        try (PreparedStatement ps2 = conn.prepareStatement("SELECT ISNULL(SUM(dv.cantidad), 0) FROM DetalleVenta dv JOIN Venta v ON dv.id_venta = v.id_venta WHERE CAST(v.fecha as DATE) = CAST(GETDATE() as DATE)");
             ResultSet rs2 = ps2.executeQuery()) { if(rs2.next()) prodsVendidosHoy = rs2.getInt(1); }

        try (PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) FROM Producto WHERE stock < 15");
             ResultSet rs3 = ps3.executeQuery()) { if(rs3.next()) alertasStockBajo = rs3.getInt(1); }
    } catch(Exception e) {
        System.out.println("Error: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin | Cine Sistema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root { --cine-red: #e50914; --cine-dark: #1b1b1b; --cine-gray: #f4f6f9; }
        body { background-color: var(--cine-gray); font-family: 'Segoe UI', sans-serif; }
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
        .page-title { font-weight: 900; color: #111827; font-size: 1.8rem; letter-spacing: -0.5px; }
        .stat-card { background: white; border-radius: 16px; padding: 25px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.02); }
        .stat-data h6 { color: #9ca3af; font-size: 0.75rem; font-weight: 700; letter-spacing: 1px; margin-bottom: 8px; }
        .stat-data h2 { font-weight: 900; color: #111827; margin: 0; font-size: 2.2rem; }
        .stat-icon { width: 55px; height: 55px; border-radius: 14px; display: flex; justify-content: center; align-items: center; font-size: 1.4rem; }
        .icon-bg-red { background-color: #fee2e2; color: #ef4444; }
        .icon-bg-blue { background-color: #e0f2fe; color: #0ea5e9; }
        .icon-bg-warning { background-color: #fff3cd; color: #ffc107; }
        .table-container { background: white; border-radius: 16px; padding: 30px; margin-top: 35px; box-shadow: 0 2px 10px rgba(0,0,0,0.02); }
        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .table-title { font-weight: 800; font-size: 1.2rem; color: #111827; margin: 0; display: flex; align-items: center; gap: 10px; }
        .custom-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .custom-table th { background-color: #f9fafb; color: #6b7280; font-size: 0.75rem; font-weight: 700; padding: 15px; text-transform: uppercase; letter-spacing: 0.5px; text-align: center; border-bottom: none;}
        .custom-table td { padding: 18px 15px; vertical-align: middle; text-align: center; border-bottom: 1px solid #f3f4f6; color: #374151; font-weight: 500; font-size: 0.95rem; }
        .badge-success { background-color: #dcfce7; color: #15803d; padding: 6px 16px; border-radius: 20px; font-weight: 700; font-size: 0.8rem; display: inline-block;}
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
            <a href="inicio.jsp" class="nav-item active"><i class="fa-solid fa-chart-pie"></i> Dashboard</a>
            <a href="historial.jsp" class="nav-item"><i class="fa-solid fa-receipt"></i> Historial de Ventas</a>
            <a href="inventario.jsp" class="nav-item"><i class="fa-solid fa-box-open"></i> Inventario</a>
            <a href="personal.jsp" class="nav-item"><i class="fa-solid fa-user-group"></i> Personal</a>
            <a href="<%=request.getContextPath()%>/HistorialBoletosServlet" class="nav-item"><i class="fa-solid fa-ticket"></i> Historial Boletos</a>
        </nav>
        <div class="logout-box mt-auto">
            <a href="login.jsp" class="logout-link"><i class="fa-solid fa-arrow-right-from-bracket"></i> Cerrar Sesión</a>
        </div>
    </div>

    <div class="main-wrapper">
        <div class="page-header d-flex justify-content-between align-items-center mb-4">
            <h2 class="page-title m-0">Resumen del Negocio</h2>
            <a href="inicio.jsp?exportar=true" class="btn btn-sm btn-light border shadow-sm">
                <i class="fa-solid fa-download me-2"></i> Exportar Excel
            </a>
        </div>
        
        <div class="row g-4">
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-data">
                        <h6>VENTAS DE HOY</h6>
                        <h2>S/ <%= String.format("%.2f", ventasHoy) %> </h2>
                    </div>
                    <div class="stat-icon icon-bg-red"><i class="fa-solid fa-money-bill-trend-up"></i></div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-data">
                        <h6>PRODUCTOS VENDIDOS (HOY)</h6>
                        <h2><%= prodsVendidosHoy %> <span class="fs-6 text-muted fw-normal">unidades</span></h2>
                    </div>
                    <div class="stat-icon icon-bg-blue"><i class="fa-solid fa-box-open"></i></div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card">
                    <div class="stat-data">
                        <h6>STOCK BAJO (< 15)</h6>
                        <h2 class="text-warning"><%= alertasStockBajo %> <span class="fs-6 text-muted fw-normal">productos</span></h2>
                    </div>
                    <div class="stat-icon icon-bg-warning"><i class="fa-solid fa-triangle-exclamation"></i></div>
                </div>
            </div>
        </div>

        <div class="table-container">
            <div class="table-header">
                <h3 class="table-title">
                    <i class="fa-solid fa-clock-rotate-left text-danger" style="font-size: 1.1rem;"></i> Últimas Ventas Registradas
                </h3>
            </div>
            
            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>Nº BOLETA</th>
                            <th>FECHA Y HORA</th>
                            <th>CAJERO</th>
                            <th>TOTAL PAGADO</th>
                            <th>ESTADO</th>
                            <th>ACCIÓN</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            Connection conn2 = null;
                            try {
                                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                                conn2 = new com.confiteria.dao.YGestorBaseDatos().getConnection();
                                String sql = "SELECT TOP 5 v.id_venta, v.fecha, v.total, p.nombre_completo " +
                                             "FROM Venta v INNER JOIN Personal p ON v.id_personal = p.id_personal " +
                                             "ORDER BY v.fecha DESC";
                                try (PreparedStatement psTable = conn2.prepareStatement(sql);
                                     ResultSet rsTable = psTable.executeQuery()) {
                                    
                                    while(rsTable.next()) {
                                        int idVenta = rsTable.getInt("id_venta");
                                        String fecha = rsTable.getString("fecha"); 
                                        if(fecha != null && fecha.length() > 16) fecha = fecha.substring(0, 16);
                                        
                                        double total = rsTable.getDouble("total");
                                        String cajero = rsTable.getString("nombre_completo");
                                        String nroBoleta = String.format("%05d", idVenta);
                                        
                                        StringBuilder filasHtml = new StringBuilder();
                                        try (PreparedStatement psDet = conn2.prepareStatement("SELECT pr.nombre, dv.cantidad, dv.subtotal FROM DetalleVenta dv JOIN Producto pr ON dv.id_producto = pr.id_producto WHERE dv.id_venta = ?")) {
                                            psDet.setInt(1, idVenta);
                                            try (ResultSet rsDet = psDet.executeQuery()) {
                                                while(rsDet.next()){
                                                    filasHtml.append("<tr>")
                                                             .append("<td class='text-start fw-bold' style='color: #374151;'>").append(rsDet.getString("nombre")).append("</td>")
                                                             .append("<td class='fw-bold text-muted'>").append(rsDet.getInt("cantidad")).append("</td>")
                                                             .append("<td class='text-end fw-bold' style='color: #111827;'>S/ ").append(String.format("%.2f", rsDet.getDouble("subtotal")).replace(",", ".")).append("</td>")
                                                             .append("</tr>");
                                                }
                                            }
                                        }
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
                                }
                            } catch(Exception e) {
                                out.print("<tr><td colspan='6' class='text-danger'>Error: " + e.getMessage() + "</td></tr>");
                            } finally {
                                try { if(conn2 != null) conn2.close(); } catch(Exception e) {}
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
            document.getElementById('modal-boleta-id').innerText = "#" + nroBoleta;
            document.getElementById('modal-cajero').innerText = cajero;
            document.getElementById('modal-total').innerText = total;
            document.getElementById('modal-fecha').innerText = fecha;
            
            const filasOcultas = document.getElementById('filas-' + nroBoleta).innerHTML;
            document.getElementById('modal-tbody').innerHTML = filasOcultas;
        }
    </script>
</body>
</html>