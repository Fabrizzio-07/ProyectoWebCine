/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.boletos.Controladores;

import com.boletos.Tools.BoletosUtil;
import com.boletos.BD.PeliculaBoletosBD;
import com.boletos.Clases.PeliculaBoletos;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author ancaj
 */
@WebServlet(name = "CajeroPeliculasServlet", urlPatterns = {"/CajeroPeliculasServlet"})
public class CajeroPeliculasServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private final PeliculaBoletosBD peliculaBD = new PeliculaBoletosBD();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!BoletosUtil.esCajero(request)) {
            if (BoletosUtil.esAdministrador(request)) {
                response.sendRedirect(request.getContextPath() + "/inicio.jsp");
            }else{
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String buscar = request.getParameter("buscar");
        String genero = request.getParameter("genero");

        ArrayList<PeliculaBoletos> peliculas;

        if (buscar != null && !buscar.trim().isEmpty()) {
            peliculas = peliculaBD.buscarPeliculasPorNombre(buscar.trim());
        } else {
            peliculas = peliculaBD.listarPeliculasActivas();
        }

        if (genero != null && !genero.trim().isEmpty()) {
            peliculas = filtrarPorGenero(peliculas, genero.trim());
        }

        request.setAttribute("peliculas", peliculas);
        request.setAttribute("generos", peliculaBD.listarGeneros());
        request.setAttribute("buscar", buscar != null ? buscar : "");
        request.setAttribute("generoSeleccionado", genero != null ? genero : "");

        RequestDispatcher rd = request.getRequestDispatcher("/boletos_seleccionarPelicula.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private ArrayList<PeliculaBoletos> filtrarPorGenero(ArrayList<PeliculaBoletos> lista, String genero) {
        ArrayList<PeliculaBoletos> filtrada = new ArrayList<PeliculaBoletos>();

        if (lista == null) {
            return filtrada;
        }

        for (int i = 0; i < lista.size(); i++) {
            PeliculaBoletos p = lista.get(i);
            if (p.getGenero() != null && p.getGenero().equalsIgnoreCase(genero)) {
                filtrada.add(p);
            }
        }
        return filtrada;
    }
}
