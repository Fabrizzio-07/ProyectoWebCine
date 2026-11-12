<%-- 
    Document   : boletos_historial
    Created on : 25 jun. 2026, 12:40:37
    Author     : ancaj
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.boletos.Tools.BoletosUtil"%>
<%@page import="java.util.Locale"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.LocalTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="com.boletos.Clases.VentaAsientoBoletos"%>
<%@page import="com.boletos.Clases.VentaBoletos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%!
    private String html(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    private String url(String s) {
        try {
            return java.net.URLEncoder.encode(s == null ? "" : s, "UTF-8");
        } catch (Exception e) {
            return "";
        }
    }

    private String money(java.math.BigDecimal v) {
        if (v == null) return "S/ 0.00";
        return String.format(Locale.US, "S/ %.2f", v.doubleValue());
    }

    private String date(LocalDate d) {
        if (d == null) return "";
        return d.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    private String time(LocalTime t) {
        if (t == null) return "";
        return t.format(DateTimeFormatter.ofPattern("HH:mm"));
    }
%>

<%
    String cp = request.getContextPath();

    ArrayList<VentaBoletos> historial = (ArrayList<VentaBoletos>) request.getAttribute("historial");
    if (historial == null) historial = new ArrayList<VentaBoletos>();

    String buscar = (String) request.getAttribute("buscar");
    String fechaInicio = (String) request.getAttribute("fechaInicio");
    String fechaFin = (String) request.getAttribute("fechaFin");
    String filtro = (String) request.getAttribute("filtro");

    if (buscar == null) buscar = "";
    if (fechaInicio == null) fechaInicio = "";
    if (fechaFin == null) fechaFin = "";
    if (filtro == null) filtro = "";

    VentaBoletos ventaDetalle = (VentaBoletos) request.getAttribute("ventaDetalle");
    ArrayList<VentaAsientoBoletos> asientosDetalle = (ArrayList<VentaAsientoBoletos>) request.getAttribute("asientosDetalle");
    String asientosDetalleTexto = (String) request.getAttribute("asientosDetalleTexto");
    if (asientosDetalleTexto == null) asientosDetalleTexto = "";

    String usuarioNombre = BoletosUtil.obtenerNombreUsuario(request);
    if (usuarioNombre == null || usuarioNombre.trim().isEmpty()) {
        usuarioNombre = "Administrador";
    }
    String[] partesNombre = usuarioNombre.trim().split("\\s+");
    String usuarioInicial;

    if (partesNombre.length >= 2) {
        usuarioInicial = (partesNombre[0].substring(0,1)
                + partesNombre[1].substring(0,1)).toUpperCase();
    } else {
        usuarioInicial = partesNombre[0].substring(0,1).toUpperCase();
    }
%>

<%
    if (!BoletosUtil.esAdministrador(request)) {
        if (BoletosUtil.esCajero(request)) {
            response.sendRedirect(request.getContextPath() + "/CajeroPeliculasServlet");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Boletos | Historial</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/CSS/sidebar-admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root{
            --cine-red:#e50914;
            --cine-dark:#121212;
            --cine-gray:#f4f6f9;
            --cine-card:#ffffff;
            --cine-text:#111827;
            --cine-muted:#6b7280;
        }
        body{margin:0;font-family:'Segoe UI',sans-serif;background:var(--cine-gray);color:var(--cine-text);overflow-x:hidden;}
        .main-wrapper{margin-left:260px;padding:28px 30px 36px;}
        .page-top{
            background:#fff;border-radius:18px;padding:18px 20px;display:flex;justify-content:space-between;align-items:center;
            box-shadow:0 6px 24px rgba(0,0,0,.05);margin-bottom:22px;gap:16px;
        }
        .page-title{margin:0;font-size:1.55rem;font-weight:900;letter-spacing:-.4px;}
        .page-subtitle{margin:2px 0 0;color:var(--cine-muted);font-size:.95rem;}
        .panel{background:#fff;border-radius:18px;box-shadow:0 6px 24px rgba(0,0,0,.05);padding:20px;}
        .filters-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:12px;align-items:end;}
        .label-small{font-size:.82rem;font-weight:700;color:#374151;margin-bottom:6px;}
        .btn-cine{
            background:var(--cine-red);border:none;color:#fff;border-radius:12px;padding:.8rem 1rem;font-weight:800;
        }
        .btn-cine:hover{background:#c20712;color:#fff;}
        .btn-cine-outline{
            border:1px solid var(--cine-red);color:var(--cine-red);border-radius:12px;background:#fff;font-weight:800;
        }
        .btn-cine-outline:hover{background:var(--cine-red);color:#fff;}
        .btn-soft{border-radius:12px;font-weight:700;}
        .detail-card{
            border:1px solid #fee2e2;background:#fff7f7;border-radius:18px;padding:18px;margin-bottom:18px;
        }
        .detail-title{font-weight:900;margin:0 0 8px;font-size:1.05rem;}
        .detail-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px;}
        .detail-box{
            background:#fff;border:1px solid #f3f4f6;border-radius:14px;padding:12px 14px;
        }
        .detail-label{font-size:.78rem;color:var(--cine-muted);font-weight:700;}
        .detail-value{font-weight:800;word-break:break-word;}
        .table-wrap{overflow:auto;border-radius:16px;border:1px solid #e5e7eb;}
        table{margin-bottom:0;}
        thead th{background:#111827;color:#fff;border:0 !important;white-space:nowrap;}
        tbody td{vertical-align:middle;white-space:nowrap;}
        .empty-state{
            text-align:center;padding:34px 20px;color:var(--cine-muted);
        }
        @media (max-width:992px){
            .sidebar{position:relative;width:100%;height:auto;}
            .main-wrapper{margin-left:0;}
            .filters-grid,.detail-grid{grid-template-columns:1fr;}
            .page-top{flex-direction:column;align-items:flex-start;}
        }
        .user-status { color: #28a745; font-size: 0.75rem; display: flex; align-items: center; gap: 6px; margin-top: 3px; }
        .status-dot { width: 8px; height: 8px; background-color: #28a745; border-radius: 50%; box-shadow: 0 0 5px rgba(40, 167, 69, 0.5); }
        
        .user-role{font-size:.78rem;color:#a3a3a3;}
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="brand-logo">
            <i class="fa-solid fa-clapperboard text-danger"></i> CINE SISTEMA
        </div>

        <div class="user-box">
            <div class="user-avatar"><%= usuarioInicial %></div>
            <div class="user-info">
                <span class="user-name"><%= html(usuarioNombre) %></span>
                <span class="user-status"><span class="status-dot"></span> Online</span>
            </div>
        </div>

        <nav class="nav-menu">
            <a href="inicio.jsp" class="nav-item"><i class="fa-solid fa-chart-pie"></i> Dashboard</a>
            <a href="historial.jsp" class="nav-item"><i class="fa-solid fa-receipt"></i> Historial de Ventas</a>
            <a href="inventario.jsp" class="nav-item"><i class="fa-solid fa-box-open"></i> Inventario</a>
            <a href="personal.jsp" class="nav-item"><i class="fa-solid fa-user-group"></i> Personal</a>
            <a href="<%=request.getContextPath()%>/HistorialBoletosServlet" class="nav-item active"><i class="fa-solid fa-ticket"></i> Historial Boletos</a>
        </nav>

        <div class="logout-box mt-auto">
            <a href="login.jsp" class="logout-link">
                <i class="fa-solid fa-arrow-right-from-bracket"></i> Cerrar Sesión
            </a>
        </div>
    </div>

    <main class="main-wrapper">
        <div class="page-top">
            <div>
                <h1 class="page-title">Historial de ventas de boletos</h1>
                <p class="page-subtitle">Consulta, filtra, exporta y revisa cada venta registrada.</p>
            </div>
            <div class="d-flex gap-2 flex-wrap">
                <a class="btn btn-cine-outline btn-soft"
                   href="<%=cp%>/EstadisticasBoletosServlet?fechaInicio=<%= url(fechaInicio) %>&fechaFin=<%= url(fechaFin) %>">
                    <i class="fa-solid fa-chart-column me-1"></i> Estadísticas
                </a>
                <a class="btn btn-cine btn-soft"
                   href="<%=cp%>/ExportarBoletosCsvServlet?filtro=<%= url(filtro) %>&buscar=<%= url(buscar) %>&fechaInicio=<%= url(fechaInicio) %>&fechaFin=<%= url(fechaFin) %>">
                    <i class="fa-solid fa-file-csv me-1"></i> Exportar CSV
                </a>
            </div>
        </div>

        <section class="panel mb-4">
            <form class="filters-grid" method="get" action="<%=cp%>/HistorialBoletosServlet">
                <div>
                    <div class="label-small">Buscar</div>
                    <input type="text" name="buscar" value="<%= html(buscar) %>" class="form-control" placeholder="Cliente, película o código">
                </div>
                <div>
                    <div class="label-small">Fecha inicio</div>
                    <input type="date" name="fechaInicio" value="<%= html(fechaInicio) %>" class="form-control">
                </div>
                <div>
                    <div class="label-small">Fecha fin</div>
                    <input type="date" name="fechaFin" value="<%= html(fechaFin) %>" class="form-control">
                </div>
                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-cine"><i class="fa-solid fa-filter me-1"></i> Filtrar</button>
                    <a class="btn btn-outline-secondary btn-soft" href="<%=cp%>/HistorialBoletosServlet">Limpiar</a>
                </div>
            </form>
        </section>

        <%
            if (ventaDetalle != null) {
        %>
        <section class="detail-card">
            <h2 class="detail-title"><i class="fa-solid fa-circle-info me-1"></i> Detalle de la venta #<%= ventaDetalle.getIdVenta() %></h2>
            <div class="detail-grid mb-3">
                <div class="detail-box">
                    <div class="detail-label">Cliente</div>
                    <div class="detail-value"><%= html(ventaDetalle.getCliente()) %></div>
                </div>
                <div class="detail-box">
                    <div class="detail-label">Película</div>
                    <div class="detail-value"><%= html(ventaDetalle.getNombrePelicula()) %></div>
                </div>
                <div class="detail-box">
                    <div class="detail-label">Asientos</div>
                    <div class="detail-value"><%= html(asientosDetalleTexto) %></div>
                </div>
                <div class="detail-box">
                    <div class="detail-label">Fecha función</div>
                    <div class="detail-value"><%= ventaDetalle.getFechaFuncion() != null ? ventaDetalle.getFechaFuncion().toString() : "" %></div>
                </div>
                <div class="detail-box">
                    <div class="detail-label">Hora función</div>
                    <div class="detail-value"><%= ventaDetalle.getHoraFuncion() != null ? ventaDetalle.getHoraFuncion().toString() : "" %></div>
                </div>
                <div class="detail-box">
                    <div class="detail-label">Total</div>
                    <div class="detail-value"><%= money(ventaDetalle.getMontoTotal()) %></div>
                </div>
            </div>

            <div class="table-wrap">
                <table class="table table-striped table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Asiento(s)</th>
                            <th>Cajero</th>
                            <th>Fecha de compra</th>
                            <th>Hora de compra</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (asientosDetalle != null && !asientosDetalle.isEmpty()) {
                        %>
                        <tr>
                            <td>
                                <div class="seat-list" style="justify-content:flex-start;">
                                    <% for (VentaAsientoBoletos a : asientosDetalle) { %>
                                        <span class="seat-pill"><%= html(a.getAsiento()) %></span>
                                    <% } %>
                                </div>
                            </td>
                            <td><%= html(ventaDetalle.getNombrePersonal()) %></td>
                            <td><%= ventaDetalle.getFechaCompra() != null ? ventaDetalle.getFechaCompra().toString() : "" %></td>
                            <td><%= ventaDetalle.getHoraCompra() != null ? ventaDetalle.getHoraCompra().toString() : "" %></td>
                        </tr>
                        <%
                            } else {
                        %>
                        <tr>
                            <td colspan="4" class="empty-state">No se encontraron asientos para esta venta.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </section>
        <%
            }
        %>

        <section class="panel">
            <div class="table-wrap">
                <table class="table table-striped table-hover align-middle">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Fecha compra</th>
                            <th>Hora compra</th>
                            <th>Cliente</th>
                            <th>Película</th>
                            <th>Sala</th>
                            <th>Función</th>
                            <th>Total</th>
                            <th>Cajero</th>
                            <th>Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (historial.isEmpty()) {
                        %>
                        <tr>
                            <td colspan="10" class="empty-state">No hay ventas que mostrar con estos filtros.</td>
                        </tr>
                        <%
                            } else {
                                for (VentaBoletos v : historial) {
                        %>
                        <tr>
                            <td><strong>#<%= v.getIdVenta() %></strong></td>
                            <td><%= v.getFechaCompra() != null ? v.getFechaCompra().toString() : "" %></td>
                            <td><%= v.getHoraCompra() != null ? v.getHoraCompra().toString() : "" %></td>
                            <td><%= html(v.getCliente()) %></td>
                            <td><%= html(v.getNombrePelicula()) %></td>
                            <td><%= v.getSala() %></td>
                            <td>
                                <%= v.getFechaFuncion() != null ? v.getFechaFuncion().toString() : "" %>
                                <br>
                                <small class="text-muted"><%= v.getHoraFuncion() != null ? v.getHoraFuncion().toString() : "" %></small>
                            </td>
                            <td><%= money(v.getMontoTotal()) %></td>
                            <td><%= html(v.getNombrePersonal()) %></td>
                            <td>
                                <a class="btn btn-sm btn-cine-outline"
                                   href="<%=cp%>/HistorialBoletosServlet?idVentaDetalle=<%= v.getIdVenta() %>&buscar=<%= url(buscar) %>&fechaInicio=<%= url(fechaInicio) %>&fechaFin=<%= url(fechaFin) %>&filtro=<%= url(filtro) %>">
                                    Ver detalle
                                </a>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</body>
</html>
