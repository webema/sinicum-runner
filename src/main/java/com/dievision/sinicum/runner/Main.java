package com.dievision.sinicum.runner;

import org.apache.catalina.LifecycleException;
import org.apache.catalina.connector.Connector;
import org.apache.catalina.startup.Tomcat;

import com.beust.jcommander.JCommander;

public class Main {
    public static void main(String[] args) throws Exception {
        Configuration config = new Configuration();
        new JCommander(config, args);

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(config.getHttpPort());
        tomcat.getConnector().setURIEncoding("UTF-8");
        if (config.isHttpsScheme()) {
            tomcat.getConnector().setScheme("https");
            tomcat.getConnector().setProxyPort(443);
        }
        if (config.getProxyPort() != null) {
            tomcat.getConnector().setProxyPort(config.getProxyPort());
        }
        if (config.getAjpPort() != null) {
            Connector connector = new Connector("AJP/1.3");
            connector.setPort(config.getAjpPort());
            connector.setURIEncoding("UTF-8");
            tomcat.getService().addConnector(connector);
        }
        tomcat.setBaseDir(config.getBaseDir());
        tomcat.getHost().setAppBase(config.getAppBase());
        if (config.getHostname() != null) {
            tomcat.setHostname(config.getHostname());
            tomcat.getHost().setName(config.getHostname());
        }
        tomcat.addWebapp(config.getContextPath(), config.getAppBase());
        addShutdownHook(tomcat);
        tomcat.start();
        tomcat.getServer().await();
    }

    private static void addShutdownHook(final Tomcat tomcat) {
        Runtime runtime = Runtime.getRuntime();
        runtime.addShutdownHook(new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    tomcat.getServer().stop();
                } catch (LifecycleException e) {
                    System.err.println("Error stopping Tomcat: " + e.toString());
                }
            }
        }));
    }
}
