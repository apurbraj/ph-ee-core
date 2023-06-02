package org.mifos.connector.notification.sms.message;


import io.camunda.zeebe.client.ZeebeClient;
import org.apache.camel.LoggingLevel;
import org.apache.camel.builder.RouteBuilder;
import org.mifos.connector.notification.provider.config.ProviderConfig;
import org.mifos.connector.notification.template.TemplateConfig;
import org.mifos.connector.notification.template.TemplateDefaultConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;

import static org.mifos.connector.notification.camel.config.CamelProperties.*;
import static org.mifos.connector.notification.zeebe.ZeebeVariables.*;


@Component
public class CreateMessageRoute extends RouteBuilder {

    @Autowired
    private ProviderConfig providerConfig;


    @Autowired
    private ZeebeClient zeebeClient;

    @Autowired
    private TemplateConfig templateConfig;
    @Autowired
    private TemplateDefaultConfig templateDefaultConfig;

    @Value("${zeebe.client.ttl}")
    private int timeToLive;

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Override
        public void configure() throws Exception {

            from("direct:create-failure-messages")
                    .id("create-messages")
                    .log(LoggingLevel.INFO, "Creating message")
                    .process(exchange ->{
                        Map<String, Object> newVariables = new HashMap<>();
                        if(exchange.getProperty(TYPE).equals(EMAIL_AND_SMS) || exchange.getProperty(TYPE).equals(EMAIL_TYPE)) {
                            StringWriter email = new StringWriter();
                            TemplateConfig config = templateDefaultConfig.replaceTemplatePlaceholders(templateConfig, exchange);
                            config.getEmailFailureTemplate().merge(templateConfig.getVelocityContext(), email);
                            exchange.setProperty(DELIVERY_EMAIL, email);
                            newVariables.put(EMAIL_TO_SEND, exchange.getProperty(DELIVERY_EMAIL).toString());
                        }
                        if(exchange.getProperty(TYPE).equals(EMAIL_AND_SMS) || exchange.getProperty(TYPE).equals(SMS_TYPE)) {
                            StringWriter message = new StringWriter();
                            TemplateConfig config = templateDefaultConfig.replaceTemplatePlaceholders(templateConfig, exchange);
                            config.getSMSFailureTemplate().merge(templateConfig.getVelocityContext(), message);
                            exchange.setProperty(DELIVERY_MESSAGE, message);
                            newVariables.put(MESSAGE_TO_SEND, exchange.getProperty(DELIVERY_MESSAGE).toString());
                        }

//                        newVariables.put(MESSAGE_TO_SEND, exchange.getProperty(DELIVERY_MESSAGE).toString());
                        newVariables.put(MESSAGE_INTERNAL_ID,exchange.getProperty(INTERNAL_ID).toString());
                        zeebeClient.newSetVariablesCommand(Long.parseLong(exchange.getProperty(INTERNAL_ID).toString()))
                                .variables(newVariables)
                                .send()
                                .join();
                    })
                    .log(LoggingLevel.INFO, "Creating message completed with message :${exchangeProperty."+DELIVERY_MESSAGE+"}")
                   ;



        from("direct:create-success-messages")
                .id("create-success messages")
                .log(LoggingLevel.INFO, "Drafting success message")
                .process(exchange ->{
                    StringWriter message = new StringWriter();
                    if(exchange.getProperty(TYPE).equals(EMAIL_TYPE)){
                        TemplateConfig config = templateDefaultConfig.replaceTemplatePlaceholders(templateConfig,exchange);
                        config.getEmailSuccessTemplate().merge(templateConfig.getVelocityContext(),message);
                    }
                    if(exchange.getProperty(TYPE).equals(SMS_TYPE)){
                        TemplateConfig config = templateDefaultConfig.replaceTemplatePlaceholders(templateConfig,exchange);
                        config.getSMSSuccessTemplate().merge(templateConfig.getVelocityContext(),message);
                    }

                    exchange.setProperty(DELIVERY_MESSAGE, message);
                    Map<String, Object> newVariables = new HashMap<>();
                    newVariables.put(MESSAGE_TO_SEND, exchange.getProperty(DELIVERY_MESSAGE).toString());
                    newVariables.put(MESSAGE_INTERNAL_ID,exchange.getProperty(INTERNAL_ID).toString());
                    zeebeClient.newSetVariablesCommand(Long.parseLong(exchange.getProperty(INTERNAL_ID).toString()))
                            .variables(newVariables)
                            .send()
                            .join();
                })
                .log(LoggingLevel.INFO, "Creating message completed with message :" +
                        "${exchangeProperty."+DELIVERY_MESSAGE+"}");

    }

}


