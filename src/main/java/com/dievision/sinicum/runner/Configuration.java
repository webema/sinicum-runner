package com.dievision.sinicum.runner;

import com.beust.jcommander.Parameter;

/**
 *
 */
public class Configuration {
    @Parameter(names = "-p", description = "HTTP Port")
    private Integer httpPort = 8080;

    @Parameter(names = {"-a", "--ajp"}, description = "AJP Port")
    private Integer ajpPort;

    @Parameter(names = {"-c", "--context"}, description = "AJP Port")
    private String contextPath = "";

    @Parameter(names = {"-n", "--hostname"}, description = "Tomcat Hostname")
    private String hostname;

    @Parameter(names = {"-S", "--https-scheme"}, description = "Tomcat Connector HTTPS Scheme")
    private boolean scheme;

    @Parameter(names = {"-P", "--proxyport"}, description = "Tomcat Connector Proxy port")
    private Integer proxyPort;

    @Parameter(names = "--basedir", description = "Tomcat Base directory", required = true)
    private String baseDir;

    @Parameter(names = "--appbase", description = "Tomcat App Base directory", required = true)
    private String appBase;

    public Integer getHttpPort() {
        return httpPort;
    }

    public Integer getAjpPort() {
        return ajpPort;
    }

    public String getAppBase() {
        return appBase;
    }

    public String getBaseDir() {
        return baseDir;
    }

    public String getContextPath() {
        return contextPath;
    }

    public String getHostname() {
        return hostname;
    }

    public boolean isHttpsScheme() {
        return scheme;
    }

    public Integer getProxyPort() {
        if (isHttpsScheme() && proxyPort == null) {
            return 443;
        } else {
            return proxyPort;
        }
    }
}
