package org.example.a3;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/converter")
public class CurrencyConverter extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException{

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String usdInput = request.getParameter("usd");

            if(usdInput == null || usdInput.trim().isEmpty()){
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Please provide the usd Parameter. Example: ?usd=10\"}");
                return;
            }

            double usdAmount = Double.parseDouble(usdInput);
            int exchangeRate = 4000;
            double khrAmount = usdAmount * exchangeRate;

            String jsonResponse = String.format("{\n" +
                    "\"usd_amount\": %.1f,\n" +
                    "\"exchangeRate\": %d,\n" +
                    "\"khr_amount\": %.1f \n}",
                    usdAmount, exchangeRate, khrAmount
            );
            out.print(jsonResponse);
        }catch (NumberFormatException e){
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"The Usd value must be a valid number!\"}");
        }finally {
            out.flush();
        }
    }
}

