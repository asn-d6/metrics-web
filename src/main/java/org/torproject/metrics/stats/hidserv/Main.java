/* Copyright 2016--2020 The Tor Project
 * See LICENSE for licensing information */

package org.torproject.metrics.stats.hidserv;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;

/** Main class for updating extrapolated network totals of hidden-service
 * statistics.  The main method of this class can be executed as often as
 * new statistics are needed, though callers must ensure that executions
 * do not overlap. */
public class Main {

  private static final Logger logger = LoggerFactory.getLogger(Main.class);

  private static final File baseDir = new File(
      org.torproject.metrics.stats.main.Main.modulesDir, "hidserv");

  /** Parses new descriptors, extrapolate contained statistics using
   * computed network fractions, aggregate results, and writes results to
   * disk. */
  public static void main(String[] args) {

    /* Initialize directories and file paths. */
    File[] inDirectories = new File[] {
        new File(org.torproject.metrics.stats.main.Main.descriptorsDir,
            "recent/relay-descriptors/consensuses"),
        new File(org.torproject.metrics.stats.main.Main.descriptorsDir,
            "recent/relay-descriptors/extra-infos") };
    File statusDirectory = new File(baseDir, "status");

    /* Initialize parser and read parse history to avoid parsing
     * descriptor files that haven't changed since the last execution. */
    logger.info("Initializing parser and reading parse history...");
    DocumentStore<ReportedHidServStats> reportedHidServStatsStore =
        new DocumentStore<>(ReportedHidServStats.class);
    DocumentStore<ComputedNetworkFractions>
        computedNetworkFractionsStore = new DocumentStore<>(
        ComputedNetworkFractions.class);
    Parser parser = new Parser(inDirectories, statusDirectory,
        reportedHidServStatsStore, computedNetworkFractionsStore);
    parser.readParseHistory();

    /* Parse new descriptors and store their contents using the document
     * stores. */
    logger.info("Parsing descriptors...");
    parser.parseDescriptors();

    /* Write the parse history to avoid parsing descriptor files again
     * next time.  It's okay to do this now and not at the end of the
     * execution, because even if something breaks apart below, it's safe
     * not to parse descriptor files again. */
    logger.info("Writing parse history...");
    parser.writeParseHistory();

    /* Extrapolate reported statistics using computed network fractions
     * and write the result to disk using a document store.  The result is
     * a single file with extrapolated network totals based on reports by
     * single relays. */
    logger.info("Extrapolating statistics...");
    DocumentStore<ExtrapolatedHidServStats> extrapolatedHidServStatsStore
        = new DocumentStore<>(ExtrapolatedHidServStats.class);
    Extrapolator extrapolator = new Extrapolator(statusDirectory,
        reportedHidServStatsStore, computedNetworkFractionsStore,
        extrapolatedHidServStatsStore);
    if (!extrapolator.extrapolateHidServStats()) {
      logger.warn("Could not extrapolate statistics. Terminating.");
      return;
    }

    /* Go through all extrapolated network totals and aggregate them.
     * This includes calculating daily weighted interquartile means, among
     * other statistics.  Write the result to a .csv file that can be
     * processed by other tools. */
    logger.info("Aggregating statistics...");
    File hidservStatsExtrapolatedCsvFile = new File(baseDir,
        "stats/hidserv.csv");
    Aggregator aggregator = new Aggregator(statusDirectory,
        extrapolatedHidServStatsStore, hidservStatsExtrapolatedCsvFile);
    aggregator.aggregateHidServStats();

    /* End this execution. */
    logger.info("Terminating.");
  }
}

