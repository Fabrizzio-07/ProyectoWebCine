<%-- 
    Document   : personal.jsp
    Created on : 23 jun. 2026, 11:13:55
    Author     : marina
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.confiteria.dao.YGestorPersonal"%>
<%@page import="com.confiteria.modelo.YPersonal"%>
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
            <h2 class="page-title m-0">Gestión de Personal</h2>
            <a href="registro.jsp" class="btn btn-danger">
                <i class="fa-solid fa-user-plus"></i>
                    Registrar
            </a>

            <a href="ExportarPersonalServlet"
class="btn btn-success">

<i class="fa-solid fa-file-excel"></i>

Exportar Excel

</a>
        </div>
                    <form action="personal.jsp" method="get">

    <div class="card shadow-sm border-0 mb-4">
        <div class="card-body">

            <div class="row g-3">

                <div class="col-md-5">
                    <input
                        type="text"
                        name="txtBuscar"
                        class="form-control"
                        placeholder="Buscar por nombre o usuario..."
                        value="${param.txtBuscar}">
                </div>

                <div class="col-md-3">
                    <select name="rol" class="form-select">

                        <option value="">Todos los roles</option>

                        <option value="Administrador"
                            ${param.rol=="Administrador"?"selected":""}>
                            Administrador
                        </option>

                        <option value="Cajero"
                            ${param.rol=="Cajero"?"selected":""}>
                            Cajero
                        </option>

                    </select>
                </div>

                <div class="col-md-2">
                    <button
                        type="submit"
                        class="btn btn-dark w-100">

                        <i class="fa fa-search"></i>
                        Buscar

                    </button>
                </div>

                <div class="col-md-2">

                    <a href="personal.jsp"
                       class="btn btn-secondary w-100">

                        Limpiar

                    </a>

                </div>

            </div>

        </div>
    </div>

</form>
                    <div class="card shadow-sm border-0">

    <div class="card-body">
        <%
    String texto = request.getParameter("txtBuscar");
    String rol = request.getParameter("rol");

    if(texto == null){
        texto = "";
    }

    if(rol == null){
        rol = "";
    }

    YGestorPersonal gestor = new YGestorPersonal();

    ArrayList<YPersonal> listaPersonal;

    if(texto.equals("") && rol.equals("")){
        listaPersonal = gestor.listarPersonal();
    }else{
        listaPersonal = gestor.buscarPersonal(texto, rol);
    }

%>
        
<%
String registro = request.getParameter("registro");

if("ok".equals(registro)){
%>

<div class="alert alert-success">

Empleado registrado correctamente.

</div>

<%
}
%>
<table class="table table-hover align-middle">

            <thead class="table-dark">

                <tr>

                    <th>ID</th>

                    <th>Nombre</th>

                    <th>Usuario</th>

                    <th>Rol</th>

                    <th>Estado</th>

                    <th>Acciones</th>

                </tr>

            </thead>

            <tbody>

<%
for(YPersonal p : listaPersonal){
%>

<tr>

    <td><%= p.getIdPersonal() %></td>

    <td><%= p.getNombreCompleto() %></td>

    <td><%= p.getUsuario() %></td>

    <td><%= p.getRol().getNombreRol() %></td>

    <td>

        <% if(p.isEstado()){ %>

            <span class="badge bg-success">
                Activo
            </span>

        <% } else { %>

            <span class="badge bg-danger">
                Inactivo
            </span>

        <% } %>

    </td>

    <td>

        <a href="EditarPersonalServlet?id=<%= p.getIdPersonal() %>"
   class="btn btn-warning btn-sm">
    <i class="fa fa-pen"></i>
</a>

        <a href="#"
   class="btn btn-danger btn-sm"
   onclick="confirmarEliminar(
       <%= p.getIdPersonal() %>,
       '<%= p.getNombreCompleto() %>')">

    <i class="fa fa-trash"></i>

</a>

    </td>

</tr>

<%
}
%>

</tbody>

        </table>

    </div>

</div>
                
        

       
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>

function confirmarEliminar(id,nombre){

    Swal.fire({

        title:'¿Eliminar empleado?',

        text:'Se eliminará el empleado "'+nombre+'".',

        icon:'warning',

        showCancelButton:true,

        confirmButtonColor:'#d33',

        cancelButtonColor:'#6c757d',

        confirmButtonText:'Sí, eliminar',

        cancelButtonText:'Cancelar'

    }).then((result)=>{

        if(result.isConfirmed){

            window.location=
            "PersonalServlet?accion=eliminar&id="+id;

        }

    });

}

</script>
<%
String mensaje = request.getParameter("mensaje");

if("eliminado".equals(mensaje)){
%>

<script>

Swal.fire({

    icon:'success',

    title:'Empleado eliminado',

    text:'El registro fue eliminado correctamente.',

    confirmButtonColor:'#e50914'

});

</script>

<%

}

%>
    </body>
</html>
