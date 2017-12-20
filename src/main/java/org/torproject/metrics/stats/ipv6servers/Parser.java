/* Copyright 2017 The Tor Project
 * See LICENSE for licensing information */

package org.torproject.metrics.stats.ipv6servers;

import org.torproject.descriptor.BridgeNetworkStatus;
import org.torproject.descriptor.NetworkStatusEntry;
import org.torproject.descriptor.RelayNetworkStatusConsensus;
import org.torproject.descriptor.RelayServerDescriptor;
import org.torproject.descriptor.ServerDescriptor;

import org.apache.commons.lang.StringUtils;

import java.time.Instant;
import java.time.ZoneId;

/** Parser that extracts all relevant parts from (relay and bridge) server
 * descriptors and (relay and bridge) statuses and creates data objects for
 * them. */
class Parser {

  /** Parse a (relay or bridge) server descriptor. */
  ParsedServerDescriptor parseServerDescriptor(
      ServerDescriptor serverDescriptor) {
    ParsedServerDescriptor parsedDescriptor = new ParsedServerDescriptor();
    parsedDescriptor.digest = serverDescriptor.getDigestSha1Hex();
    for (String orAddress : serverDescriptor.getOrAddresses()) {
      if (StringUtils.countMatches(orAddress, ":") >= 2) {
        parsedDescriptor.announced = true;
        break;
      }
    }
    if (serverDescriptor instanceof RelayServerDescriptor) {
      parsedDescriptor.advertisedBandwidth =
          Math.min(serverDescriptor.getBandwidthRate(),
              serverDescriptor.getBandwidthBurst());
      if (serverDescriptor.getBandwidthObserved() >= 0) {
        parsedDescriptor.advertisedBandwidth =
            Math.min(parsedDescriptor.advertisedBandwidth,
                serverDescriptor.getBandwidthObserved());
      }
      parsedDescriptor.exiting
          = null != serverDescriptor.getIpv6DefaultPolicy()
          && !("reject".equals(serverDescriptor.getIpv6DefaultPolicy())
          && "1-65535".equals(serverDescriptor.getIpv6PortList()));
    }
    return parsedDescriptor;
  }

  /** Parse a relay network status. */
  ParsedNetworkStatus parseRelayNetworkStatusConsensus(
      RelayNetworkStatusConsensus consensus) throws Exception {
    return this.parseStatus(true, consensus.getValidAfterMillis(),
        consensus.getStatusEntries().values());
  }

  /** Parse a bridge network status. */
  ParsedNetworkStatus parseBridgeNetworkStatus(BridgeNetworkStatus status)
      throws Exception {
    return this.parseStatus(false, status.getPublishedMillis(),
        status.getStatusEntries().values());
  }

  private ParsedNetworkStatus parseStatus(boolean isRelay, long timestampMillis,
      Iterable<NetworkStatusEntry> entries) {
    ParsedNetworkStatus parsedStatus = new ParsedNetworkStatus();
    parsedStatus.isRelay = isRelay;
    parsedStatus.timestamp = Instant.ofEpochMilli(timestampMillis)
        .atZone(ZoneId.of("UTC")).toLocalDateTime();
    for (NetworkStatusEntry entry : entries) {
      if (!entry.getFlags().contains("Running")) {
        continue;
      }
      parsedStatus.running++;
    }
    for (NetworkStatusEntry entry : entries) {
      if (!entry.getFlags().contains("Running")) {
        continue;
      }
      ParsedNetworkStatus.Entry parsedEntry = new ParsedNetworkStatus.Entry();
      parsedEntry.digest = entry.getDescriptor().toLowerCase();
      if (isRelay) {
        parsedEntry.guard = entry.getFlags().contains("Guard");
        parsedEntry.exit = entry.getFlags().contains("Exit")
            && !entry.getFlags().contains("BadExit");
        parsedEntry.reachable = false;
        for (String orAddress : entry.getOrAddresses()) {
          if (StringUtils.countMatches(orAddress, ":") >= 2) {
            parsedEntry.reachable = true;
            break;
          }
        }
      }
      parsedStatus.entries.add(parsedEntry);
    }
    return parsedStatus;
  }
}
