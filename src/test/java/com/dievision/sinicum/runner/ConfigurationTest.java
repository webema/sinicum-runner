package com.dievision.sinicum.runner;

import org.junit.Before;
import org.junit.Test;

import com.beust.jcommander.JCommander;
import static junit.framework.Assert.*;

/**
 *
 */
public class ConfigurationTest {
    private Configuration config;
    private String[] argv;

    @Before
    public void setUp() {
        this.config = new Configuration();
        this.argv = new String[]{"--basedir", ".", "--appbase", "."};
    }

    @Test
    public void testDefaultHttpPort() {
        new JCommander(config, argv);
        assertEquals(8080, config.getHttpPort().intValue());
    }

    @Test
    public void testHttpPortOption() {
        addArgs(new String[]{ "-p", "3000" });
        new JCommander(config, argv);
        assertEquals(3000, config.getHttpPort().intValue());
    }

    @Test
    public void testAjpNullByDefault() {
        new JCommander(config, argv);
        assertNull(config.getAjpPort());
    }

    @Test
    public void testSetAjpPort() {
        addArgs(new String[]{ "--ajp", "8009" });
        new JCommander(config, argv);
        assertEquals(8009, config.getAjpPort().intValue());
    }

    @Test
    public void testHostname() {
        addArgs(new String[]{ "-n", "ahostname" });
        new JCommander(config, argv);
        assertEquals("ahostname", config.getHostname());
    }

    @Test
    public void testSslScheme() {
        addArgs(new String[]{ "-S" });
        new JCommander(config, argv);
        assertEquals(true, config.isHttpsScheme());
        assertEquals(443, config.getProxyPort().intValue());
    }

    @Test
    public void testSslSchemeWithProxyPort() {
        addArgs(new String[]{ "-S", "-P", "4242" });
        new JCommander(config, argv);
        assertEquals(true, config.isHttpsScheme());
        assertEquals(4242, config.getProxyPort().intValue());
    }

    @Test
    public void testBaseDirAppBase() {
        argv = new String[]{ "--basedir", "/path/to/dir", "--appbase", "/path/to/appbase"};
        new JCommander(config, argv);
        assertEquals("/path/to/dir", config.getBaseDir());
        assertEquals("/path/to/appbase", config.getAppBase());
    }

    @Test
    public void contextPathIsEmptyByDefault() {
        new JCommander(config, argv);
        assertEquals("", config.getContextPath());
    }

    @Test
    public void contextPathCanBeSet() {
        addArgs(new String[]{"-c", "/somepath"});
        new JCommander(config, argv);
        assertEquals("/somepath", config.getContextPath());
    }

    private void addArgs(String[] args) {
        String[] newArgv = new String[argv.length + args.length];
        System.arraycopy(argv, 0, newArgv, 0, argv.length);
        System.arraycopy(args, 0, newArgv, argv.length, args.length);
        this.argv = newArgv;
    }

}
