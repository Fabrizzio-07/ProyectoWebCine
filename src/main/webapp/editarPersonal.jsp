<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
            <a href="inicio.jsp" class="nav-item "><i class="fa-solid fa-chart-pie"></i> Dashboard</a>
            <a href="historial.jsp" class="nav-item"><i class="fa-solid fa-receipt"></i> Historial de Ventas</a>
            <a href="inventario.jsp" class="nav-item"><i class="fa-solid fa-box-open"></i> Inventario</a>
            <a href="personal.jsp" class="nav-item active"><i class="fa-solid fa-user-group"></i> Personal</a>
            <a href="<%=request.getContextPath()%>/HistorialBoletosServlet" class="nav-item"><i class="fa-solid fa-ticket"></i> Historial Boletos</a>
        </nav>
        <div class="logout-box mt-auto">
            <a href="login.jsp" class="logout-link"><i class="fa-solid fa-arrow-right-from-bracket"></i> Cerrar Sesión</a>
        </div>
    </div>
                <div class="main-wrapper">
        <div class="page-header d-flex justify-content-between align-items-center mb-4">
            <h2 class="page-title m-0">Editar Personal</h2>
        </div>
        <div class="card shadow-sm border-0">

            <div class="card-header bg-danger text-white">

                <i class="fa-solid fa-user-plus me-2"></i>

                Nuevo Empleado

            </div>
<%
String error = request.getParameter("error");

if("password".equals(error)){
%>

<div class="alert alert-danger">

Las contraseñas no coinciden.

</div>

<%
}
%>
<%
String registro = request.getParameter("registro");

if("error".equals(registro)){
%>

<div class="alert alert-danger">

No se pudo registrar el empleado.

</div>

<%
}
%>
            <div class="card-body">

                <form action="ActualizarPersonalServlet" method="post">

    <input
    type="hidden"
    name="id"
    value="${persona.idPersonal}">

                <div class="row">

                    <div class="col-md-6 mb-3">

                        <label class="form-label">
                            Nombre Completo
                        </label>
<input
type="text"
name="nombreCompleto"
class="form-control"
value="${persona.nombreCompleto}"
required
pattern="[A-Za-zÁÉÍÓÚáéíóúÑñ ]+"
title="Solo se permiten letras y espacios"
oninput="this.value=this.value.replace(/[^A-Za-zÁÉÍÓÚáéíóúÑñ ]/g,'')">

                    </div>

                    <div class="col-md-6 mb-3">

                        <label class="form-label">
                            Usuario
                        </label>

                        <input
type="text"
name="usuario"
class="form-control"
value="${persona.usuario}"
required>

                    </div>

                </div>
                <div class="row">

    <div class="col-md-6 mb-3">

        <label class="form-label">

            Contraseña

        </label>

        <input
type="password"
name="password"
class="form-control"
value="${persona.password}"
required>

    </div>

    <div class="col-md-6 mb-3">

        <label class="form-label">

            Confirmar Contraseña

        </label>

        <input
type="password"
name="confirmarPassword"
class="form-control"
value="${persona.password}"
required>

    </div>

</div>
           
                <div class="row">

    <div class="col-md-6 mb-3">

        <label>Rol</label>

       <select
        name="idRol"
        class="form-select">
            <option value="2"
${persona.rol.idRol==2?'selected':''}>
Administrador
</option>

<option value="1"
${persona.rol.idRol==1?'selected':''}>
Cajero
</option>
        </select>

    </div>

</div> 
                <div class="mb-4">

<label class="form-label">

Estado

</label>

<div>

<div class="form-check form-check-inline">

<input
class="form-check-input"
type="radio"
name="estado"
value="1"
${persona.estado ? 'checked' : ''}>

<label class="form-check-label">

Activo

</label>

</div>

<div class="form-check form-check-inline">

<input
class="form-check-input"
type="radio"
name="estado"
value="0"
${!persona.estado ? 'checked' : ''}>

<label class="form-check-label">

Inactivo

</label>

</div>

</div>

</div>
                <div class="text-end">

<a
href="personal.jsp"
class="btn btn-secondary">

<i class="fa fa-arrow-left"></i>

Volver

</a>

<button
type="reset"
class="btn btn-warning">

<i class="fa fa-eraser"></i>

Limpiar

</button>

<button type="submit" class="btn btn-danger">
    <i class="fa fa-pen"></i> Actualizar
</button>

</div>
                    
                </form>

            </div>

        </div>

       
    </div>
    </body>
</html>
