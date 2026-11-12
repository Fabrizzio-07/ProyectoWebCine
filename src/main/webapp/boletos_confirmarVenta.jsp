<%-- 
    Document   : boletos_confirmarVenta
    Created on : 25 jun. 2026, 12:40:26
    Author     : ancaj
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.boletos.Tools.BoletosUtil"%>
<%@page import="java.util.Locale"%>
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

    private String money(java.math.BigDecimal v) {
        if (v == null) return "S/ 0.00";
        return String.format(Locale.US, "S/ %.2f", v.doubleValue());
    }
%>

<%
    String cp = request.getContextPath();
    String mensajeExito = (String) request.getAttribute("mensajeExito");
    String error = (String) request.getAttribute("error");
    Integer idVentaGenerada = (Integer) request.getAttribute("idVentaGenerada");

    VentaBoletos venta = (VentaBoletos) request.getAttribute("ventaRegistrada");
    ArrayList<VentaAsientoBoletos> asientos = (ArrayList<VentaAsientoBoletos>) request.getAttribute("asientosSeleccionados");
    if (asientos == null) {
        asientos = new ArrayList<VentaAsientoBoletos>();
    }

    String nombrePelicula = "";
    String tipo = "";
    String cliente = "";
    String fechaFuncion = "";
    String horaFuncion = "";
    String fechaCompra = "";
    String horaCompra = "";
    String sala = "";
    java.math.BigDecimal total = java.math.BigDecimal.ZERO;

    if (venta != null) {
        nombrePelicula = venta.getNombrePelicula();
        tipo = venta.getTipo();
        cliente = venta.getCliente();
        fechaFuncion = venta.getFechaFuncion() != null ? venta.getFechaFuncion().toString() : "";
        horaFuncion = venta.getHoraFuncion() != null ? venta.getHoraFuncion().toString() : "";
        fechaCompra = venta.getFechaCompra() != null ? venta.getFechaCompra().toString() : "";
        horaCompra = venta.getHoraCompra() != null ? venta.getHoraCompra().toString() : "";
        sala = String.valueOf(venta.getSala());
        total = venta.getMontoTotal();
    }
    
    String usuarioNombre = BoletosUtil.obtenerNombreUsuario(request);
    if (usuarioNombre == null || usuarioNombre.trim().isEmpty()) {
        usuarioNombre = "Cajero";
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
    if (!BoletosUtil.esCajero(request)) {
        if (BoletosUtil.esAdministrador(request)) {
            response.sendRedirect(request.getContextPath() + "/inicio.jsp");
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
    <title>Boletos | Confirmar venta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/CSS/sidebar-cajero.css">
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
            box-shadow:0 6px 24px rgba(0,0,0,.05);margin-bottom:22px;
        }
        .page-title{margin:0;font-size:1.55rem;font-weight:900;letter-spacing:-.4px;}
        .page-subtitle{margin:2px 0 0;color:var(--cine-muted);font-size:.95rem;}
        .filter-card{
            background:#fff;border-radius:18px;padding:18px 20px;box-shadow:0 6px 24px rgba(0,0,0,.05);margin-bottom:22px;
        }
        .filter-label{font-size:.82rem;font-weight:700;color:#374151;margin-bottom:6px;}
        .form-control,.form-select{
            border-radius:12px;border:1px solid #dde3ea;padding:.72rem .95rem;box-shadow:none;
        }
        .btn-cine{
            background:var(--cine-red);border:none;color:#fff;border-radius:12px;padding:.75rem 1rem;font-weight:700;
        }
        .btn-cine:hover{background:#c20712;color:#fff;}
        .btn-cine-outline{
            border:1px solid var(--cine-red);color:var(--cine-red);border-radius:12px;background:#fff;font-weight:700;
        }
        .btn-cine-outline:hover{background:var(--cine-red);color:#fff;}
        .movie-grid{
            display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:20px;
        }
        .movie-card{
            background:#fff;border-radius:20px;overflow:hidden;box-shadow:0 8px 26px rgba(0,0,0,.06);
            display:flex;flex-direction:column;height:100%;
        }
        .poster-wrap{
            width:100%;aspect-ratio:2 / 3;background:linear-gradient(135deg,#1f2937,#111827);
            position:relative;overflow:hidden;
        }
        .poster-img{
            width:100%;height:100%;object-fit:cover;display:block;
        }
        .poster-fallback{
            width:100%;height:100%;display:flex;align-items:center;justify-content:center;flex-direction:column;
            color:#fff;text-align:center;padding:18px;
        }
        .poster-fallback i{font-size:3rem;margin-bottom:10px;color:#ffb3b7;}
        .movie-body{padding:16px;display:flex;flex-direction:column;gap:10px;flex:1;}
        .movie-title{font-weight:800;font-size:1.02rem;line-height:1.2;margin:0;height:40px;overflow:hidden;}
        .movie-meta{display:flex;flex-wrap:wrap;gap:8px;}
        .pill{
            display:inline-flex;align-items:center;gap:6px;padding:6px 10px;border-radius:999px;background:#f3f4f6;
            font-size:.8rem;color:#374151;font-weight:700;
        }
        .pill-red{background:#fff1f2;color:#b91c1c;}
        .movie-desc{font-size:.9rem;color:var(--cine-muted);margin:0;min-height:42px;}
        .schedule-title{font-size:.82rem;font-weight:800;color:#111827;margin-top:3px;margin-bottom:2px;}
        .schedule-list{display:flex;flex-wrap:wrap;gap:8px;}
        .schedule-btn{
            border:1px solid #d1d5db;background:#fff;border-radius:10px;padding:7px 10px;font-size:.85rem;font-weight:700;
            color:#374151;text-decoration:none;transition:.2s;
        }
        .schedule-btn:hover{background:var(--cine-dark);border-color:var(--cine-dark);color:#fff;}
        .empty-state{
            background:#fff;border-radius:18px;padding:34px 24px;text-align:center;box-shadow:0 6px 24px rgba(0,0,0,.05);
        }
        .empty-state i{font-size:3rem;color:#c7cdd6;margin-bottom:12px;}

        @media (max-width:992px){
            .sidebar{position:relative;width:100%;height:auto;}
            .main-wrapper{margin-left:0;}
        }
        .status-dot{
            display:inline-block;
            width:8px;
            height:8px;
            border-radius:50%;
            background:#22c55e;
            margin-right:6px;
            box-shadow:0 0 0 4px rgba(34,197,94,.15);
        }
        .panel{
            background:#fff;
            border-radius:18px;
            box-shadow:0 6px 24px rgba(0,0,0,.05);
            padding:20px;
        }

        .error-card,
        .success-card{
            background:#fff;
            border-radius:22px;
            box-shadow:0 8px 26px rgba(0,0,0,.06);
            padding:22px;
        }

        .success-header{
            display:flex;
            align-items:center;
            gap:16px;
            margin-bottom:20px;
        }

        .success-badge{
            width:54px;
            height:54px;
            border-radius:16px;
            background:#dcfce7;
            color:#16a34a;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:1.45rem;
            flex:0 0 auto;
        }

        .success-title{
            margin:0;
            font-size:1.35rem;
            font-weight:900;
        }

        .success-sub{
            margin:4px 0 0;
            color:var(--cine-muted);
        }

        .summary-grid{
            display:grid;
            grid-template-columns:repeat(2,minmax(0,1fr));
            gap:16px;
        }

        .summary-box{
            border:1px solid #eef2f7;
            border-radius:16px;
            padding:14px 16px;
            background:#fafafa;
        }

        .summary-label{
            font-size:.78rem;
            font-weight:800;
            color:var(--cine-muted);
            margin-bottom:4px;
            text-transform:uppercase;
            letter-spacing:.03em;
        }

        .summary-value{
            font-weight:800;
            word-break:break-word;
        }

        .seat-list{
            display:flex;
            flex-wrap:wrap;
            gap:10px;
            margin-top:8px;
        }

        .seat-pill{
            display:inline-flex;
            align-items:center;
            justify-content:center;
            min-width:44px;
            padding:8px 12px;
            border-radius:999px;
            background:#fff1f2;
            color:#b91c1c;
            font-weight:800;
            border:1px solid #fecdd3;
        }

        .total-box{
            margin-top:16px;
            border-radius:18px;
            background:linear-gradient(135deg,var(--cine-red),#b91c1c);
            color:#fff;
            padding:18px 20px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:12px;
        }

        .total-box .label{
            font-size:.8rem;
            font-weight:800;
            letter-spacing:.08em;
            text-transform:uppercase;
            opacity:.95;
        }

        .total-box .value{
            font-size:1.55rem;
            font-weight:900;
            line-height:1;
        }

        .error-card .alert{
            border-radius:14px;
        }

        @media (max-width:992px){
            .summary-grid{grid-template-columns:1fr;}
            .page-top{flex-direction:column;align-items:flex-start;}
            .total-box{flex-direction:column;align-items:flex-start;}
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="brand-logo">
            <i class="fa-solid fa-clapperboard me-2 text-danger"></i> CINE SISTEMA
        </div>

        <div class="user-info">
            <img src="https://ui-avatars.com/api/?name=${usuarioLogueado != null ? usuarioLogueado.nombreCompleto : 'Cajero'}&background=e50914&color=fff" alt="User">
            <div>
                <div class="fw-bold" style="font-size: 0.9rem;">
                    ${usuarioLogueado != null ? usuarioLogueado.nombreCompleto : 'Cajero de Turno'}
                </div>
                <div style="font-size: 0.75rem; color: #777;">En línea</div>
            </div>
        </div>

        <nav class="nav-menu">
            <a href="ventas.jsp" class="nav-item"><i class="fa-solid fa-cash-register"></i> Ventas</a>
            <a href="<%=request.getContextPath()%>/CajeroPeliculasServlet" class="nav-item active"><i class="fa-solid fa-ticket"></i> Boletos</a>
        </nav>

        <a href="login.jsp" class="logout-item">
            <i class="fa-solid fa-arrow-right-from-bracket me-2"></i> Cerrar Sesión
        </a>
    </div>

    <main class="main-wrapper">
        <section class="page-top">
            <div>
                <h1 class="page-title">Confirmar venta de boletos</h1>
                <p class="page-subtitle">Revisa el resumen final de la operación antes de continuar.</p>
            </div>
            <div class="text-end">
                <div class="fw-bold"><i class="fa-solid fa-ticket me-1 text-danger"></i> Boletos</div>
                <div class="text-muted">Venta registrada en SQL Server</div>
            </div>
        </section>

        <%
            if (error != null && error.trim().length() > 0) {
        %>
            <div class="error-card mb-3">
                <div class="alert alert-danger mb-0">
                    <i class="fa-solid fa-triangle-exclamation me-1"></i>
                    <%= html(error) %>
                </div>
                <div class="mt-3">
                    <a href="<%=cp%>/CajeroPeliculasServlet" class="btn btn-cine-outline">
                        <i class="fa-solid fa-arrow-left me-1"></i> Volver a seleccion de Peliculas
                    </a>
                </div>
            </div>
        <%
            } else if (mensajeExito != null && mensajeExito.trim().length() > 0) {
        %>
            <div class="success-card">
                <div class="success-header">
                    <div class="success-badge"><i class="fa-solid fa-circle-check"></i></div>
                    <div>
                        <h2 class="success-title">Venta registrada correctamente</h2>
                        <p class="success-sub"><%= html(mensajeExito) %></p>
                    </div>
                </div>

                <div class="summary-grid">
                    <div class="summary-box">
                        <div class="summary-label">N.º de venta</div>
                        <div class="summary-value">
                            <%= idVentaGenerada != null ? idVentaGenerada : (venta != null ? venta.getIdVenta() : 0) %>
                        </div>
                    </div>

                    <div class="summary-box">
                        <div class="summary-label">Cliente</div>
                        <div class="summary-value"><%= html(cliente.length() > 0 ? cliente : (venta != null ? venta.getCliente() : "")) %></div>
                    </div>

                    <div class="summary-box">
                        <div class="summary-label">Película</div>
                        <div class="summary-value"><%= html(nombrePelicula) %></div>
                    </div>

                    <div class="summary-box">
                        <div class="summary-label">Formato / Sala</div>
                        <div class="summary-value"><%= html(tipo) %> · Sala <%= html(sala) %></div>
                    </div>

                    <div class="summary-box">
                        <div class="summary-label">Fecha / Hora de función</div>
                        <div class="summary-value"><%= html(fechaFuncion) %> · <%= html(horaFuncion) %></div>
                    </div>

                    <div class="summary-box">
                        <div class="summary-label">Fecha / Hora de compra</div>
                        <div class="summary-value"><%= html(fechaCompra) %> · <%= html(horaCompra) %></div>
                    </div>
                </div>

                <div class="summary-box mt-3">
                    <div class="summary-label">Asientos vendidos</div>
                    <div class="seat-list">
                        <%
                            for (int i = 0; i < asientos.size(); i++) {
                                String asiento = asientos.get(i).getAsiento();
                        %>
                            <span class="seat-pill"><%= html(asiento) %></span>
                        <% } %>
                    </div>
                </div>

                <div class="total-box">
                    <div class="label">TOTAL PAGADO</div>
                    <div class="value"><%= money(total) %></div>
                </div>

                <div class="d-flex flex-wrap gap-2 mt-4">
                    <a href="<%=cp%>/CajeroPeliculasServlet" class="btn btn-cine">
                        <i class="fa-solid fa-plus me-1"></i> Nueva venta
                    </a>
                    <a href="<%=cp%>/login.jsp" class="btn btn-cine-outline">
                        <i class="fa-solid fa-house me-1"></i> Ir al login
                    </a>
                </div>
            </div>
        <%
            } else {
        %>
            <div class="panel">
                <div class="alert alert-info mb-0">
                    <i class="fa-solid fa-circle-info me-1"></i>
                    Aún no se ha confirmado ninguna venta desde este flujo.
                </div>
                <div class="mt-3">
                    <a href="<%=cp%>/CajeroPeliculasServlet" class="btn btn-cine">
                        <i class="fa-solid fa-arrow-left me-1"></i> Volver a seleccionar película
                    </a>
                </div>
            </div>
        <%
            }
        %>
    </main>
</body>
</html>
