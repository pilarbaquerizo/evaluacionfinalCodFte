package com.example.saludo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SaludoController {


    @GetMapping("/hello")
    public String saludo() {
        String tunombre = "Pilar Baquerizo";
        return "¡Hola! Bienvenido a mi aplicación para la evaluación final de Infraestructura como Código. " + tunombre;
    }

    @GetMapping("/secreto")
    public String secreto() {
        String secreto = System.getenv("password");
        return secreto;
    }
}
