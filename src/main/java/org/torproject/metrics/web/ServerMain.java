/* Copyright 2017--2020 The Tor Project
 * See LICENSE for licensing information */

package org.torproject.metrics.web;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.util.resource.Resource;
import org.eclipse.jetty.xml.XmlConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Locale;
import java.util.TimeZone;

public class ServerMain {

  private static final Logger logger
      = LoggerFactory.getLogger(ServerMain.class);

  /** Starts the web server listening for incoming client connections. */
  public static void main(String[] args) {
    Locale.setDefault(Locale.US);
    TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
    try {
      Resource jettyXml = Resource.newSystemResource("jetty.xml");
      logger.info("Reading configuration from '{}'.", jettyXml);
      XmlConfiguration configuration
          = new XmlConfiguration(jettyXml.getInputStream());
      Server server = (Server) configuration.configure();
      server.start();
      server.join();
    } catch (Exception ex) {
      logger.error("Exiting, because of: {}.", ex.getMessage(), ex);
      System.exit(1);
    }
  }
}

