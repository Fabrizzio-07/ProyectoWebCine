<%-- 
    Document   : boletos_seleccionarAsientos
    Created on : 25 jun. 2026, 12:40:18
    Author     : ancaj
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.boletos.Tools.BoletosUtil"%>
<%@page import="com.boletos.Clases.PeliculaBoletos"%>
<%@page import="com.boletos.Clases.HorarioFuncionBoletos"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%!
    private String html(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    private boolean contains(ArrayList<String> lista, String valor) {
        if (lista == null || valor == null) return false;
        for (int i = 0; i < lista.size(); i++) {
            if (valor.equalsIgnoreCase(lista.get(i))) {
                return true;
            }
        }
        return false;
    }

    private String money(double v) {
        return String.format("S/ %.2f", v);
    }
    
    private String js(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("'", "\\'");
    }
    
       private String url(String s) {
        try {
            return java.net.URLEncoder.encode(s == null ? "" : s, "UTF-8");
        } catch (Exception e) {
            return "";
        }
    }
    
%>

<%
    String cp = request.getContextPath();

    PeliculaBoletos pelicula = (PeliculaBoletos) request.getAttribute("pelicula");
    ArrayList<HorarioFuncionBoletos> horarios = (ArrayList<HorarioFuncionBoletos>) request.getAttribute("horarios");
    ArrayList<String> asientosVendidos = (ArrayList<String>) request.getAttribute("asientosVendidos");

    if (asientosVendidos == null) {
        asientosVendidos = new ArrayList<String>();
    }

    String codigoPelicula = (String) request.getAttribute("codigoPelicula");
    if (codigoPelicula == null) codigoPelicula = request.getParameter("codigoPelicula");
    if (codigoPelicula == null) codigoPelicula = "";

    String idHorarioStr = request.getParameter("idHorario");
    if(idHorarioStr == null){
        Object idHorarioObj = request.getAttribute("idHorario");
        if(idHorarioObj != null){
            idHorarioStr = String.valueOf(idHorarioObj);
        }
    }
    if (idHorarioStr == null) idHorarioStr = "";
    
    String salaStr = request.getParameter("sala");
    if (salaStr == null) {
        Object salaObj = request.getAttribute("sala");
        if (salaObj != null) {
            salaStr = String.valueOf(salaObj);
        }
    }
    if (salaStr == null) salaStr = "";

    String fechaFuncion = request.getParameter("fechaFuncion");
    if (fechaFuncion == null) {
        Object fechaObj = request.getAttribute("fechaFuncion");
        if (fechaObj != null) {
            fechaFuncion = String.valueOf(fechaObj);
        }
    }
    if (fechaFuncion == null) fechaFuncion = "";

    String horaFuncion = request.getParameter("horaFuncion");
    if (horaFuncion == null) {
        Object horaObj = request.getAttribute("horaFuncion");
        if (horaObj != null) {
            horaFuncion = String.valueOf(horaObj);
        }
    }
    if (horaFuncion == null) horaFuncion = "";

    String cliente = request.getParameter("cliente");
    if (cliente == null) {
        Object clienteObj = request.getAttribute("cliente");
        if (clienteObj != null) {
            cliente = String.valueOf(clienteObj);
        }
    }
    if (cliente == null) cliente = "";

    String poster = "";
    String titulo = "Seleccionar asientos";
    String genero = "";
    String tipo = "";
    double precioBase = 0.0;
    int duracion = 0;

    if (pelicula != null) {
        poster = pelicula.getImagenUrl();
        titulo = pelicula.getNombre();
        genero = pelicula.getGenero();
        tipo = pelicula.getTipo();
        precioBase = pelicula.getPrecioBase();
        duracion = pelicula.getDuracionMinutos();
    }

    int sala = 0;
    try {
        sala = Integer.parseInt(salaStr.trim());
    } catch (Exception e) {
        sala = 0;
    }

    String[] filas = {"A","B","C","D","E","F","G","H","I","J"};
    int columnas = 12;
    
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
    <title>Boletos | Seleccionar asientos</title>
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
        
        .content-grid{
            display:grid;
            grid-template-columns:minmax(0,1.8fr) minmax(330px,0.9fr);
            gap:20px;
            align-items:start;
        }

        .panel{
            background:#fff;
            border-radius:20px;
            box-shadow:0 8px 26px rgba(0,0,0,.06);
            padding:20px;
        }

        .movie-info{
            display:flex;
            gap:18px;
            align-items:flex-start;
            margin-bottom:18px;
        }

        .poster{
            width:180px;
            min-width:180px;
            aspect-ratio:2 / 3;
            border-radius:18px;
            overflow:hidden;
            background:linear-gradient(135deg,#1f2937,#111827);
            box-shadow:0 8px 22px rgba(0,0,0,.10);
        }

        .poster img{
            width:100%;
            height:100%;
            object-fit:cover;
            display:block;
        }

        .poster-empty{
            width:100%;
            height:100%;
            display:flex;
            align-items:center;
            justify-content:center;
            color:#fff;
        }

        .poster-empty i{
            font-size:3rem;
            color:#ffb3b7;
        }

        .mini-note{
            font-size:.86rem;
            color:var(--cine-muted);
        }

        .section-title{
            font-size:.82rem;
            font-weight:800;
            color:#111827;
            text-transform:uppercase;
            letter-spacing:.04em;
            margin-bottom:8px;
        }

        .seat-map{
            margin-top:10px;
            background:#fafafa;
            border:1px solid #e5e7eb;
            border-radius:18px;
            padding:18px;
            overflow-x:auto;
        }

        .screen-bar{
            max-width:760px;
            margin:0 auto 18px;
            height:14px;
            border-radius:999px;
            background:linear-gradient(180deg,#e5e7eb,#cbd5e1);
            display:flex;
            align-items:center;
            justify-content:center;
            color:#6b7280;
            font-size:.76rem;
            font-weight:800;
            letter-spacing:.08em;
            text-transform:uppercase;
        }

        .seat-row{
            display:grid;
            grid-template-columns:32px repeat(12,40px);
            gap:8px;
            align-items:center;
            justify-content:center;
            margin-bottom:10px;
        }

        .row-label{
            font-weight:900;
            color:#6b7280;
            text-align:center;
        }

        .seat-btn{
            width:40px;
            height:40px;
            border-radius:10px;
            border:1px solid #d1d5db;
            background:#fff;
            font-weight:800;
            font-size:.78rem;
            color:#374151;
            transition:.15s ease;
            box-shadow:0 2px 8px rgba(0,0,0,.03);
        }

        .seat-btn:hover:not(:disabled){
            transform:translateY(-1px);
            border-color:var(--cine-red);
        }

        .seat-btn.selected{
            background:var(--cine-red);
            border-color:var(--cine-red);
            color:#fff;
            box-shadow:0 8px 14px rgba(229,9,20,.18);
        }

        .seat-btn.occupied{
            background:#cbd5e1;
            border-color:#cbd5e1;
            color:#64748b;
            cursor:not-allowed;
            opacity:.95;
            box-shadow:none;
            text-decoration:none;
        }

        .legend{
            display:flex;
            justify-content:center;
            gap:16px;
            flex-wrap:wrap;
            margin-top:16px;
        }

        .legend-item{
            display:flex;
            align-items:center;
            gap:8px;
            font-size:.87rem;
            font-weight:700;
            color:#374151;
        }

        .legend-swatch{
            width:16px;
            height:16px;
            border-radius:4px;
            background:#fff;
            border:1px solid #d1d5db;
        }

        .legend-swatch.selected{
            background:var(--cine-red);
            border-color:var(--cine-red);
        }

        .legend-swatch.occupied{
            background:#cbd5e1;
            border-color:#cbd5e1;
        }

        .summary-card{
            position:sticky;
            top:24px;
        }

        .summary-title{
            margin:0 0 14px;
            font-size:1.15rem;
            font-weight:900;
        }

        .summary-line{
            border:1px solid #eef2f7;
            border-radius:16px;
            padding:14px 16px;
            background:#fafafa;
            margin-bottom:12px;
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

        .sold-count{
            font-size:.95rem;
            font-weight:800;
            color:#b91c1c;
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

        @media (max-width:992px){
            .content-grid{grid-template-columns:1fr;}
            .movie-info{flex-direction:column;}
            .poster{width:100%;min-width:0;max-width:320px;}
            .summary-card{position:static;}
            .seat-row{grid-template-columns:28px repeat(12,34px);gap:6px;}
            .seat-btn{width:34px;height:34px;font-size:.72rem;}
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
                <h1 class="page-title">Seleccionar asientos</h1>
                <p class="page-subtitle">Elige los lugares disponibles y confirma la venta.</p>
            </div>
            <div class="text-end">
                <div class="fw-bold"><i class="fa-solid fa-calendar-days me-1 text-danger"></i> <%= html(fechaFuncion) %></div>
                <div class="text-muted">Sala <%= sala %> · <%= html(horaFuncion) %></div>
            </div>
        </section>

        <div class="content-grid">
            <section class="panel">
                <div class="movie-info">
                    <div class="poster">
                        <%
                            if (poster != null && poster.trim().length() > 0) {
                        %>
                            <img src="<%= html(poster) %>" alt="<%= html(titulo) %>">
                        <%
                            } else {
                        %>
                            <div class="poster-empty">
                                <i class="fa-solid fa-film"></i>
                            </div>
                        <%
                            }
                        %>
                    </div>

                    <div class="flex-grow-1">
                        <h2 class="movie-title"><%= html(titulo) %></h2>
                        <div class="movie-meta">
                            <span class="pill"><i class="fa-solid fa-tag"></i><%= html(genero) %></span>
                            <span class="pill"><i class="fa-solid fa-clock"></i><%= duracion %> min</span>
                            <span class="pill pill-red"><i class="fa-solid fa-ticket"></i><%= html(tipo) %></span>
                            <span class="pill"><i class="fa-solid fa-door-open"></i>Sala <%= sala %></span>
                        </div>
                        <p class="mb-2 text-muted">
                            Precio por asiento: <strong><%= money(precioBase) %></strong>
                        </p>
                        <p class="mini-note mb-0">
                            Los asientos ocupados están bloqueados por la venta registrada en base de datos.
                        </p>

                        <div class="mt-3">
                            <div class="section-title">Función seleccionada</div>

                            <button type="button"
                                    class="btn btn-cine-outline"
                                    disabled>
                                <i class="fa-solid fa-clock me-1"></i>
                                <%= html(horaFuncion) %> · Sala <%= sala %>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="seat-map">
                    <div class="screen-bar"><span>Pantalla</span></div>

                    <%
                        for (int r = 0; r < filas.length; r++) {
                            String fila = filas[r];
                    %>
                        <div class="seat-row">
                            <div class="row-label"><%= fila %></div>
                            <%
                                for (int c = 1; c <= columnas; c++) {
                                    String asiento = fila + c;
                                    boolean ocupado = contains(asientosVendidos, asiento);
                            %>
                                <button type="button"
                                        class="seat-btn <%= ocupado ? "occupied" : "" %>"
                                        data-seat="<%= asiento %>"
                                        <%= ocupado ? "disabled" : "" %>
                                        onclick="toggleSeat(this)">
                                    <%= asiento %>
                                </button>
                            <% } %>
                        </div>
                    <% } %>

                    <div class="legend">
                        <div class="legend-item"><span class="legend-swatch"></span> Disponible</div>
                        <div class="legend-item"><span class="legend-swatch selected"></span> Seleccionado</div>
                        <div class="legend-item"><span class="legend-swatch occupied"></span> Ocupado</div>
                    </div>
                </div>
            </section>

            <aside class="panel summary-card">
                <h3 class="summary-title">Resumen de la venta</h3>

                <div class="summary-line">
                    <div>
                        <div class="summary-label">Película</div>
                        <div class="summary-value text-start"><%= html(titulo) %></div>
                    </div>
                </div>

                <div class="summary-line">
                    <div class="w-100">
                        <div class="summary-label">Fecha de función</div>
                        <input type="date" class="form-control mt-2" value="<%= html(fechaFuncion) %>" readonly>
                        <div class="mini-note mt-1">Fecha fija tomada desde la selección anterior.</div>
                    </div>
                </div>

                <div class="summary-line">
                    <div class="w-100">
                        <div class="summary-label">Cliente</div>
                        <input type="text"
                               id="cliente"
                               name="cliente"
                               form="frmConfirmar"
                               class="form-control mt-2"
                               value="<%= html(cliente) %>"
                               placeholder="Nombre del cliente"
                               required
                               maxlength="100">
                    </div>
                </div>

                <div class="summary-line">
                    <div>
                        <div class="summary-label">Asientos seleccionados</div>
                        <div class="summary-value text-start" id="lblAsientos">0</div>
                    </div>
                </div>

                <div class="summary-line">
                    <div>
                        <div class="summary-label">Asientos ocupados</div>
                        <div class="sold-count"><%= asientosVendidos.size() %> bloqueados</div>
                    </div>
                </div>

                <div class="total-box">
                    <div class="label">TOTAL A PAGAR</div>
                    <div class="value" id="lblTotal"><%= money(0) %></div>
                </div>

                <form id="frmConfirmar" method="post" action="<%=cp%>/ConfirmarVentaBoletosServlet" class="mt-3">
                    <input type="hidden" name="idHorario" value="<%= html(idHorarioStr) %>">
                    <input type="hidden" name="codigoPelicula" value="<%= html(codigoPelicula) %>">
                    <input type="hidden" name="fechaFuncion" value="<%= html(fechaFuncion) %>">
                    <input type="hidden" name="asientosCsv" id="asientosCsv" value="">

                    <button type="submit" class="btn btn-cine w-100 mb-2">
                        <i class="fa-solid fa-circle-check me-1"></i> Confirmar venta
                    </button>
                    <a href="<%=cp%>/CajeroPeliculasServlet" class="btn btn-cine-outline w-100">
                        <i class="fa-solid fa-arrow-left me-1"></i> Volver a películas
                    </a>
                </form>
                <p class="mini-note mt-3 mb-0">
                    Antes de confirmar, el sistema enviará los asientos seleccionados al servlet de registro.
                </p>
            </aside>
        </div>
    </main>

    <script>
        const precioBase = <%= precioBase %>;
        const asientosVendidos = [
            <%
                for (int i = 0; i < asientosVendidos.size(); i++) {
                    if (i > 0) out.print(",");
                    out.print("'" + js(asientosVendidos.get(i)) + "'");
                }
            %>
        ];

        let seleccionados = [];

        function toggleSeat(btn) {
            if (btn.disabled) return;

            const seat = btn.getAttribute('data-seat');
            const index = seleccionados.indexOf(seat);

            if (index >= 0) {
                seleccionados.splice(index, 1);
                btn.classList.remove('selected');
            } else {
                seleccionados.push(seat);
                btn.classList.add('selected');
            }

            actualizarResumen();
        }

        function actualizarResumen() {
            document.getElementById('lblAsientos').textContent = seleccionados.length;
            document.getElementById('lblTotal').textContent = 'S/ ' + (seleccionados.length * precioBase).toFixed(2);
            document.getElementById('asientosCsv').value = seleccionados.join(',');
        }

        document.getElementById('cliente').addEventListener('input', actualizarResumen);

        document.getElementById('frmConfirmar').addEventListener('submit', function (e) {
            actualizarResumen();

            const cliente = document.getElementById('cliente').value.trim();

            if (!cliente) {
                e.preventDefault();
                alert('Debes ingresar el nombre del cliente.');
                return;
            }

            if (seleccionados.length === 0) {
                e.preventDefault();
                alert('Selecciona al menos un asiento.');
                return;
            }
        });

        document.addEventListener('DOMContentLoaded', actualizarResumen);
    </script>
</body>
</html>
