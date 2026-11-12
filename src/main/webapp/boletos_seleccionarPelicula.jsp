<%-- 
    Document   : boletos_seleccionarPelicula
    Created on : 25 jun. 2026, 12:40:10
    Author     : ancaj
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.boletos.Tools.BoletosUtil"%>
<%@page import="java.util.Locale"%>
<%@page import="com.boletos.Clases.PeliculaBoletos"%>
<%@page import="com.boletos.Clases.HorarioFuncionBoletos"%>
<%@page import="com.boletos.BD.HorarioFuncionBoletosBD"%>
<%@page import="com.boletos.BD.PeliculaBoletosBD"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%!
    private String html(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    private String js(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("'", "\\'");
    }

    private String money(double v) {
        return String.format(Locale.US, "S/ %.2f", v);
    }

    private boolean equalsIgnoreCase(String a, String b) {
        if (a == null || b == null) return false;
        return a.trim().equalsIgnoreCase(b.trim());
    }
%>

<%
    String cp = request.getContextPath();

    ArrayList<PeliculaBoletos> peliculas = (ArrayList<PeliculaBoletos>) request.getAttribute("peliculas");
    ArrayList<String> generos = (ArrayList<String>) request.getAttribute("generos");

    if (peliculas == null) {
        peliculas = new ArrayList<PeliculaBoletos>();
        PeliculaBoletosBD peliculaBD = new PeliculaBoletosBD();
        peliculas = peliculaBD.listarPeliculasActivas();
    }

    if (generos == null) {
        generos = new ArrayList<String>();
        PeliculaBoletosBD peliculaBD = new PeliculaBoletosBD();
        generos = peliculaBD.listarGeneros();
    }

    String buscar = request.getParameter("buscar");
    if (buscar == null) buscar = "";
    String generoSeleccionado = request.getParameter("genero");
    if (generoSeleccionado == null) generoSeleccionado = "";

    String fechaFuncion = request.getParameter("fechaFuncion");
    if (fechaFuncion == null || fechaFuncion.trim().isEmpty()) {
        fechaFuncion = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
    }


    HorarioFuncionBoletosBD horarioBD = new HorarioFuncionBoletosBD();
    
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
    <title>Boletos | Seleccionar película</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/CSS/sidebar-cajero.css">
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
            <a href="<%=request.getContextPath()%>/CajeroPeliculasServlet" class="nav-item active">
                <i class="fa-solid fa-ticket"></i> Boletos
            </a>
        </nav>

        <a href="login.jsp" class="logout-item">
            <i class="fa-solid fa-arrow-right-from-bracket me-2"></i> Cerrar Sesión
        </a>
    </div>

    <main class="main-wrapper">
        <section class="page-top">
            <div>
                <h1 class="page-title">Seleccionar película</h1>
                <p class="page-subtitle">Elige una función y continúa con la selección de asientos.</p>
            </div>
            <div class="text-end">
                <div class="fw-bold"><i class="fa-solid fa-calendar-days me-1 text-danger"></i> Fecha de función</div>
                <div class="text-muted"><%= html(fechaFuncion) %></div>
            </div>
        </section>

        <section class="filter-card">
            <form class="row g-3 align-items-end" method="get" action="<%=cp%>/CajeroPeliculasServlet">
                <div class="col-12 col-md-4">
                    <label class="filter-label" for="buscar">Buscar película</label>
                    <input type="text" class="form-control" id="buscar" name="buscar" value="<%= html(buscar) %>" placeholder="Nombre o parte del nombre">
                </div>
                <div class="col-12 col-md-4">
                    <label class="filter-label" for="genero">Género</label>
                    <select class="form-select" id="genero" name="genero">
                        <option value="">Todos</option>
                        <%
                            for (int i = 0; i < generos.size(); i++) {
                                String g = generos.get(i);
                        %>
                            <option value="<%= html(g) %>" <%= equalsIgnoreCase(generoSeleccionado, g) ? "selected" : "" %>><%= html(g) %></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-12 col-md-4">
                    <label class="filter-label" for="fechaFuncion">Fecha de función</label>
                    <input type="date" class="form-control" id="fechaFuncion" name="fechaFuncion" value="<%= html(fechaFuncion) %>">
                </div>
                <div class="col-12 d-flex gap-2 justify-content-end">
                    <button type="submit" class="btn btn-cine-outline"><i class="fa-solid fa-filter me-1"></i> Filtrar</button>
                    <a class="btn btn-cine" href="<%=cp%>/CajeroPeliculasServlet"><i class="fa-solid fa-rotate-right me-1"></i> Limpiar</a>
                </div>
            </form>
        </section>

        <%
            if (peliculas == null || peliculas.size() == 0) {
        %>
            <div class="empty-state">
                <i class="fa-solid fa-film"></i>
                <h4 class="fw-bold mb-2">No hay películas para mostrar</h4>
                <p class="text-muted mb-0">Revisa el filtro o verifica que la tabla PeliculaBoleto tenga registros activos.</p>
            </div>
        <%
            } else {
        %>
            <section class="movie-grid">
                <%
                    for (int i = 0; i < peliculas.size(); i++) {
                        PeliculaBoletos p = peliculas.get(i);
                        ArrayList<HorarioFuncionBoletos> horarios = horarioBD.listarPorPelicula(p.getCodigo());
                        String poster = p.getImagenUrl();
                %>
                <article class="movie-card">
                    <div class="poster-wrap">
                        <%
                            if (poster != null && poster.trim().length() > 0) {
                        %>
                            <img class="poster-img" src="<%= html(poster) %>" alt="<%= html(p.getNombre()) %>">
                        <%
                            } else {
                        %>
                            <div class="poster-fallback">
                                <i class="fa-solid fa-film"></i>
                                <div class="fw-bold">Sin afiche</div>
                                <small>Agrega una URL en el SQL para mostrar la imagen</small>
                            </div>
                        <%
                            }
                        %>
                    </div>

                    <div class="movie-body">
                        <div>
                            <h3 class="movie-title"><%= html(p.getNombre()) %></h3>
                            <div class="movie-meta">
                                <span class="pill"><i class="fa-solid fa-tag"></i><%= html(p.getGenero()) %></span>
                                <span class="pill"><i class="fa-solid fa-clock"></i><%= p.getDuracionMinutos() %> min</span>
                                <span class="pill pill-red"><i class="fa-solid fa-ticket"></i><%= html(p.getTipo()) %></span>
                            </div>
                        </div>

                        <p class="movie-desc">
                            Precio base <strong><%= money(p.getPrecioBase()) %></strong>
                        </p>

                        <div>
                            <div class="schedule-title"><i class="fa-solid fa-calendar-days me-1 text-danger"></i>Funciones disponibles</div>
                            <div class="schedule-list">
                                <%
                                    if (horarios != null && horarios.size() > 0) {
                                        for (int h = 0; h < horarios.size(); h++) {
                                            HorarioFuncionBoletos horario = horarios.get(h);
                                %>
                                            <a href="javascript:void(0)"
                                               class="schedule-btn"
                                               onclick="irAsientos('<%= horario.getIdHorario() %>')">
                                                <%= horario.getHoraFuncion() != null ? horario.getHoraFuncion().toString() : "--:--" %> · Sala <%= horario.getSala() %>
                                            </a>
                                <%
                                        }
                                    } else {
                                %>
                                    <span class="text-muted small">No hay horarios cargados.</span>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </article>
                <% } %>
            </section>
        <%
            }
        %>
    </main>

    <script>
        const cp = '<%= cp %>';

        function irAsientos(idHorario) {
            const fechaFuncion = document.getElementById('fechaFuncion').value;

            if (!fechaFuncion) {
                alert('Debes seleccionar una fecha de función.');
                return;
            }

            const url = cp + '/CajeroAsientosServlet?idHorario=' + encodeURIComponent(idHorario) + '&fechaFuncion=' + encodeURIComponent(fechaFuncion);

            window.location.href = url;
        }
    </script>
</body>
</html>