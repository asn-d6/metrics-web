<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="top.jsp">
  <jsp:param name="pageTitle" value="Operation &ndash; Tor Metrics"/>
  <jsp:param name="navActive" value="Operation"/>
</jsp:include>

    <div class="container">
      <ul class="breadcrumb">
        <li><a href="index.html">Home</a></li>
        <li class="active">Operation</li>
      </ul>
    </div>

    <div class="container">
      <h1>Operation <a href="#operation" name="operation" class="anchor">#</a></h1>
      <p>You're operating a Tor relay or bridge, or you're affected in some way by somebody else operating one?  Here you can learn everything about currently running Tor nodes or even about nodes that have been running in the past.</p>
    </div>

    <div class="container">
      <h2>Network archive <a href="#archive" name="archive" class="anchor">#</a></h2>
      <p>The following tool lets you browse the network archive for relays running in the past.</p>
      <ul>
        <li><a href="https://exonerator.torproject.org/" target="_blank">ExoneraTor</a> tells you if an IP was used by a Tor relay on a given date.</li>
      </ul>
    </div>

    <div class="container">
      <h2>Network status <a href="#status" name="status" class="anchor">#</a></h2>
      <p>The following tools let you explore currently running relays and bridges.</p>
      <ul>
        <li><a href="https://play.google.com/store/apps/details?id=com.networksaremadeofstring.anonionooid" target="_blank">AnOnionooid</a> is an Android app that helps find and explore Tor relays and bridges.</li>
        <li><a href="https://atlas.torproject.org/" target="_blank">Atlas</a> displays data about single relays and bridges in the Tor network.</li>
        <li><a href="https://compass.torproject.org/" target="_blank">Compass</a> groups current relays in different ways to measure Tor's network diversity.</li>
        <li><a href="https://consensus-health.torproject.org/" target="_blank">Consensus Health</a> displays information about the current directory consensus and votes.</li>
        <li><a href="https://duckduckgo.com/" target="_blank">DuckDuckGo</a> displays Tor node details when including the keywords "tor node" in a search.</li>
        <li><a href="https://oniontip.com/" target="_blank">OnionTip</a> distributes bitcoin donations to relays that can receive them.</li>
        <li><a href="https://onionview.codeplex.com/" target="_blank">OnionView</a> plots the location of active Tor nodes on an interactive map of the world.</li>
        <li><a href="https://tor-explorer-10kapart2016.azurewebsites.net/" target="_blank">Tor Explorer</a> displays data on each individual Tor node.</li>
      </ul>
    </div>

    <div class="container">
      <h2>Network health notifications <a href="#health" name="health" class="anchor">#</a></h2>
      <p>The following tools inform you of any problems with relays and bridges.</p>
      <ul>
        <li><a href="https://lists.torproject.org/cgi-bin/mailman/listinfo/tor-consensus-health" target="_blank">Consensus Issues</a> emails directory authority operators about consensus problems.</li>
        <li><a href="http://lists.infolabe.net/lists/listinfo/infolabe-anomalies" target="_blank">OII's anomaly detection system</a> ranks countries by how anomalous their Tor usage is.</li>
      </ul>
    </div>

<jsp:include page="bottom.jsp"/>
