package com.confiteria.controlador;

import com.confiteria.dao.YGestorPersonal;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

@WebServlet("/PersonalServlet")
public class PersonalServlet extends HttpServlet {
    @Override
protected void doGet(HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    String accion = request.getParameter("accion");

    if("eliminar".equals(accion)){

    int id = Integer.parseInt(request.getParameter("id"));

    YGestorPersonal gestor = new YGestorPersonal();

    boolean eliminado = gestor.eliminarPersonal(id);

    if(eliminado){

        response.sendRedirect("personal.jsp?mensaje=eliminado");

    }else{

        response.sendRedirect("personal.jsp?mensaje=error");

    }

    return;

}

    response.sendRedirect("personal.jsp");

}

}

