package org.jsp.jsp_gram.helper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import jakarta.mail.internet.MimeMessage;

@Component
public class EmailSender {

    @Autowired
    JavaMailSender mailSender;

    @Autowired
    TemplateEngine engine;

    public void sendOtp(String to, int otp, String name) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom("geethar272003@gmail.com", "JspGram Application");
            helper.setTo(to);
            helper.setSubject("Verify Your Email through OTP");

            Context context = new Context();
            context.setVariable("name", name);
            context.setVariable("otp", otp);

            String body = engine.process("otp-template.html", context);
            helper.setText(body, true);

            mailSender.send(message);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
