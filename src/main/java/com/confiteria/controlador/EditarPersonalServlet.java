package com.confiteria.controlador;

import com.confiteria.dao.YGestorPersonal;
import com.confiteria.modelo.YPersonal;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/EditarPersonalServlet")
public class EditarPersonalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        YGestorPersonal gestor = new YGestorPersonal();

        YPersonal persona = gestor.obtenerPersonal(id);

        request.setAttribute("persona", persona);

        request.getRequestDispatcher("editarPersonal.jsp")
                .forward(request, response);
    }
}
