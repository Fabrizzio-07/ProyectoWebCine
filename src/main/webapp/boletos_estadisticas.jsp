<%-- 
    Document   : boletos_estadisticas
    Created on : 25 jun. 2026, 12:40:55
    Author     : ancaj
--%>

<%@page import="java.util.Locale"%>
<%@page import="com.boletos.Tools.BoletosUtil"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="com.boletos.Clases.EstadisticaBoletosDTO"%>
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
%>

<%
    String cp = request.getContextPath();

    EstadisticaBoletosDTO estadisticas = (EstadisticaBoletosDTO) request.getAttribute("estadisticas");
    if (estadisticas == null) {
        estadisticas = new EstadisticaBoletosDTO();
    }

    String fechaInicio = (String) request.getAttribute("fechaInicio");
    String fechaFin = (String) request.getAttribute("fechaFin");
    String buscar = (String) request.getAttribute("buscar");
    if (fechaInicio == null) fechaInicio = "";
    if (fechaFin == null) fechaFin = "";
    if (buscar == null) buscar = "";

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
    <title>Boletos | Estadísticas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/CSS/sidebar-admin.css">
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
        .filters-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px;align-items:end;}
        .label-small{font-size:.82rem;font-weight:700;color:#374151;margin-bottom:6px;}
        .btn-cine{
            background:var(--cine-red);border:none;color:#fff;border-radius:12px;padding:.8rem 1rem;font-weight:800;
        }
        .btn-cine:hover{background:#c20712;color:#fff;}
        .btn-cine-outline{
            border:1px solid var(--cine-red);color:var(--cine-red);border-radius:12px;background:#fff;font-weight:800;
        }
        .btn-cine-outline:hover{background:var(--cine-red);color:#fff;}
        .metric{
            background:#fff;border-radius:18px;padding:18px 18px 16px;box-shadow:0 6px 24px rgba(0,0,0,.05);
            border:1px solid #e5e7eb;height:100%;
        }
        .metric-icon{
            width:48px;height:48px;border-radius:14px;background:#fff1f2;color:#b91c1c;display:flex;align-items:center;justify-content:center;
            font-size:1.1rem;margin-bottom:12px;
        }
        .metric-label{font-size:.82rem;color:var(--cine-muted);font-weight:700;margin-bottom:4px;}
        .metric-value{font-size:1.55rem;font-weight:900;line-height:1.1;}
        .metric-sub{font-size:.86rem;color:var(--cine-muted);margin-top:6px;}
        .summary-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px;}
        .summary-box{
            border:1px solid #f3f4f6;border-radius:16px;padding:14px;background:#fff;
        }
        .summary-label{font-size:.8rem;color:var(--cine-muted);font-weight:700;margin-bottom:3px;}
        .summary-value{font-weight:800;word-break:break-word;}
        @media (max-width:992px){
            .sidebar{position:relative;width:100%;height:auto;}
            .main-wrapper{margin-left:0;}
            .filters-grid,.summary-grid{grid-template-columns:1fr;}
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
                <h1 class="page-title">Estadísticas de boletos</h1>
                <p class="page-subtitle">Resumen de ventas, ingresos y mejor rendimiento del periodo.</p>
            </div>
            <div class="d-flex gap-2 flex-wrap">
                <a class="btn btn-cine-outline btn-soft"
                   href="<%=cp%>/HistorialBoletosServlet?buscar=<%= url(buscar) %>&fechaInicio=<%= url(fechaInicio) %>&fechaFin=<%= url(fechaFin) %>">
                    <i class="fa-solid fa-clipboard-list me-1"></i> Historial
                </a>
                <a class="btn btn-cine-outline btn-soft"
                   href="<%=cp%>/EstadisticasBoletosServlet">
                    <i class="fa-solid fa-broom me-1"></i> Limpiar
                </a>
                <a class="btn btn-cine btn-soft"
                   href="<%=cp%>/EstadisticasBoletosServlet?buscar=<%= url(buscar) %>&fechaInicio=<%= url(fechaInicio) %>&fechaFin=<%= url(fechaFin) %>">
                    <i class="fa-solid fa-rotate me-1"></i> Actualizar
                </a>
            </div>
        </div>

        <section class="panel mb-4">
            <form class="filters-grid" method="get" action="<%=cp%>/EstadisticasBoletosServlet">
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
                <div class="d-grid">
                    <button type="submit" class="btn btn-cine"><i class="fa-solid fa-filter me-1"></i> Filtrar</button>
                </div>
            </form>
        </section>

        <section class="row g-3 mb-4">
            <div class="col-12 col-md-6 col-xl-3">
                <div class="metric">
                    <div class="metric-icon"><i class="fa-solid fa-cash-register"></i></div>
                    <div class="metric-label">Total ventas</div>
                    <div class="metric-value"><%= estadisticas.getTotalVentas() %></div>
                    <div class="metric-sub">Ventas registradas en el periodo</div>
                </div>
            </div>
            <div class="col-12 col-md-6 col-xl-3">
                <div class="metric">
                    <div class="metric-icon"><i class="fa-solid fa-ticket"></i></div>
                    <div class="metric-label">Total boletos</div>
                    <div class="metric-value"><%= estadisticas.getTotalBoletos() %></div>
                    <div class="metric-sub">Asientos vendidos en total</div>
                </div>
            </div>
            <div class="col-12 col-md-6 col-xl-3">
                <div class="metric">
                    <div class="metric-icon"><i class="fa-solid fa-sack-dollar"></i></div>
                    <div class="metric-label">Monto total</div>
                    <div class="metric-value"><%= money(estadisticas.getMontoTotal()) %></div>
                    <div class="metric-sub">Ingresos del periodo seleccionado</div>
                </div>
            </div>
            <div class="col-12 col-md-6 col-xl-3">
                <div class="metric">
                    <div class="metric-icon"><i class="fa-solid fa-star"></i></div>
                    <div class="metric-label">Mejor película</div>
                    <div class="metric-value" style="font-size:1.15rem;"><%= html(estadisticas.getMejorPelicula()) %></div>
                    <div class="metric-sub">Por mayor ingreso</div>
                </div>
            </div>
        </section>

        <section class="panel">
            <div class="summary-grid">
                <div class="summary-box">
                    <div class="summary-label">Mejor cajero</div>
                    <div class="summary-value"><%= html(estadisticas.getMejorCajero()) %></div>
                </div>
                <div class="summary-box">
                    <div class="summary-label">Boletos de la mejor película</div>
                    <div class="summary-value"><%= estadisticas.getBoletosVendidosMejorPelicula() %></div>
                </div>
                <div class="summary-box">
                    <div class="summary-label">Ingreso de la mejor película</div>
                    <div class="summary-value"><%= money(estadisticas.getIngresoMejorPelicula()) %></div>
                </div>
                <div class="summary-box">
                    <div class="summary-label">Periodo consultado</div>
                    <div class="summary-value">
                        <%= fechaInicio.isEmpty() ? "Sin fecha inicial" : fechaInicio %>
                        -
                        <%= fechaFin.isEmpty() ? "Sin fecha final" : fechaFin %>
                    </div>
                </div>
            </div>
        </section>
    </main>
</body>
</html>
