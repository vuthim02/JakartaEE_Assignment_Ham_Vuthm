package com.example;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/CalculateGrade")
public class CalculateGrade extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();

        // 1. Retrieve data from the HTML Form
        String name = request.getParameter("studentName");
        int score = Integer.parseInt(request.getParameter("score"));

        // 2. Business Logic Processing
        String grade;
        String color;

        if (score >= 90) {
            grade = "A";
            color = "green";
        } else if (score >= 80) {
            grade = "B";
            color = "blue";
        } else if (score >= 50) {
            grade = "C";
            color = "orange";
        } else {
            grade = "F (Fail)";
            color = "red";
        }

        // 3. Display the result back to the Browser
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Academic Results</title>");
        out.println("</head>");

        out.println("<body>");
        out.println("<h2>Academic Results</h2>");

        out.println("<p><b>Student Name:</b> " + name + "</p>");
        out.println("<p><b>Score Received:</b> " + score + " points</p>");

        out.println(
                "<p><b>Grade:</b> " +
                        "<span style='color:" + color +
                        "; font-size:20px;'>" +
                        grade +
                        "</span></p>"
        );

        out.println("<br>");
        out.println("<a href='grade.html'>Go Back</a>");

        out.println("</body>");
        out.println("</html>");
    }
}