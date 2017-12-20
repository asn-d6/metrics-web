/* Copyright 2017 The Tor Project
 * See LICENSE for licensing information */

package org.torproject.metrics.stats.ipv6servers;

import org.torproject.descriptor.BridgeNetworkStatus;
import org.torproject.descriptor.Descriptor;
import org.torproject.descriptor.DescriptorReader;
import org.torproject.descriptor.DescriptorSourceFactory;
import org.torproject.descriptor.RelayNetworkStatusConsensus;
import org.torproject.descriptor.ServerDescriptor;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.Arrays;

/** Main class of the ipv6servers module that imports relevant parts from server
 * descriptors and network statuses into a database, and exports aggregate
 * statistics on IPv6 support to a CSV file. */
public class Main {

  private static Logger log = LoggerFactory.getLogger(Main.class);

  private static String[][] paths =  {
    {"recent", "relay-descriptors", "consensuses"},
    {"recent", "relay-descriptors", "server-descriptors"},
    {"recent", "bridge-descriptors", "statuses"},
    {"recent", "bridge-descriptors", "server-descriptors"},
    {"archive", "relay-descriptors", "consensuses"},
    {"archive", "relay-descriptors", "server-descriptors"},
    {"archive", "bridge-descriptors", "statuses"},
    {"archive", "bridge-descriptors", "server-descriptors"}};

  /** Run the module. */
  public static void main(String[] args) throws Exception {

    log.info("Starting ipv6servers module.");

    log.info("Reading descriptors and inserting relevant parts into the "
        + "database.");
    DescriptorReader reader = DescriptorSourceFactory.createDescriptorReader();
    File historyFile = new File(Configuration.history);
    reader.setHistoryFile(historyFile);
    Parser parser = new Parser();
    try (Database database = new Database(Configuration.database)) {
      try {
        for (Descriptor descriptor : reader.readDescriptors(
            Arrays.stream(paths).map((String[] path)
                -> Paths.get(Configuration.descriptors, path).toFile())
            .toArray(File[]::new))) {
          if (descriptor instanceof ServerDescriptor) {
            database.insertServerDescriptor(parser.parseServerDescriptor(
                (ServerDescriptor) descriptor));
          } else if (descriptor instanceof RelayNetworkStatusConsensus) {
            database.insertStatus(parser.parseRelayNetworkStatusConsensus(
                (RelayNetworkStatusConsensus) descriptor));
          } else if (descriptor instanceof BridgeNetworkStatus) {
            database.insertStatus(parser.parseBridgeNetworkStatus(
                (BridgeNetworkStatus) descriptor));
          } else {
            log.debug("Skipping unknown descriptor of type {}.",
                descriptor.getClass());
          }
        }

        log.info("Aggregating database entries.");
        database.aggregate();

        log.info("Committing all updated parts in the database.");
        database.commit();
      } catch (SQLException sqle) {
        log.error("Cannot recover from SQL exception while inserting or "
            + "aggregating data. Rolling back and exiting.", sqle);
        database.rollback();
        return;
      }
      reader.saveHistoryFile(historyFile);

      log.info("Querying aggregated statistics from the database.");
      Iterable<OutputLine> output = database.queryServersIpv6();
      log.info("Writing aggregated statistics to {}.", Configuration.output);
      if (null != output) {
        new Writer().write(Paths.get(Configuration.output), output);
      }

      log.info("Terminating ipv6servers module.");
    } catch (SQLException sqle) {
      log.error("Cannot recover from SQL exception while querying. Not writing "
          + "output file.", sqle);
    }
  }
}
