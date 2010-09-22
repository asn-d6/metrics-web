        <h2>Tor Metrics Portal: Graphs</h2>
        <br/>
        <p>The graphs on this page visualize a small portion of the data
        gathered in the Tor Metrics Project. They are generated by a
        combination of shell scripts, Java applications, and R code (for
        details see the <a href="tools.html">Tools</a> section). The
        following graphs are available:</p>
        <ul>
          <li><a href="#relays">Relays in the Tor network</a></li>
          <li><a href="#newusers">New or returning, directly connecting
            Tor users</a></li>
          <li><a href="#recurringusers">Recurring, directly connecting Tor
            users</a></li>
          <li><a href="#bridgeusers">Tor users via bridges</a></li>
          <li><a href="#torperf">Time to complete requests</a></li>
          <li><a href="#gettor">Packages requested from GetTor</a></li>
          <li><a href="#versions">Relay versions</a></li>
          <li><a href="#platforms">Relay platforms</a></li>
          <li><a href="#bandwidth">Relay bandwidth</a></li>
        </ul>
        <br/>
        <a id="relays"/>
        <h3>Relays in the Tor network</h3>
        <br/>
        <p>The number of relays in the Tor network can be extracted from
        the hourly published network status consensuses.</p>
        <img src="graphs/networksize/networksize-30d.png"/>
        <p>Other graphs related to <a href="consensus-graphs.html">network
        size</a> and <a href="exit-relays-graphs.html">exit relays</a> can
        be found on separate pages.</p>
        <br/>
        <a id="newusers"/>
        <h3>New or returning, directly connecting Tor users</h3>
        <br/>
        <p>Users connecting to the Tor network for the first time request
        a list of running relays from one of currently seven directory
        authorities. Likewise, returning users whose network information
        is out of date connect to one of the directory authorities to
        download a fresh list of relays. The following graphs display an
        estimate of new or returning Tor users based on the requests as
        seen by gabelmoo, one of the directory authorities.</p>
        <img src="graphs/new-users/iran-new-30d.png"/>
        <p>Graphs for other countries can be found on a
        <a href="new-users-graphs.html">separate page</a>.</p>
        <br/>
        <a id="recurringusers"/>
        <h3>Recurring, directly connecting Tor users</h3>
        <br/>
        <p>After being connected to the Tor network, users need to refresh
        their list of running relays on a regular basis. They send their
        requests to one out of a few hundred directory mirrors to save
        bandwidth of the directory authorities. The following graphs show
        an estimate of recurring Tor users based on the requests as seen
        by trusted, a particularly fast directory mirror.</p>
        <img src="graphs/direct-users/iran-direct-30d.png"/>
        <p>Graphs for other countries can be found on a
        <a href="recurring-users-graphs.html">separate page</a>.</p>
        <br/>
        <a id="bridgeusers"/>
        <h3>Tor users via bridges</h3>
        <br/>
        <p>Users who cannot connect directly to the Tor network instead
        connect via bridges, which are non-public relays. The following
        graphs display an estimate of Tor users via bridges based on the
        unique IP addresses as seen by a few hundred bridges.</p>
        <img src="graphs/bridge-users/iran-bridges-30d.png"/>
        <p>Graphs for other countries can be found on a
        <a href="bridge-users-graphs.html">separate page</a>.</p>
        <br/>
        <a id="torperf"/>
        <h3>Time to complete requests</h3>
        <br/>
        <p>The following graphs show the performance of the Tor network as
        experienced by its users. The graphs contain the average (median)
        time to request files of three different sizes over the network as
        well as first and third quartile of request times.</p>
        <img src="graphs/torperf/torperf-50kb-torperf-6m.png"/>
        <p>Graphs for other file sizes or time intervals can be found on a
        <a href="torperf-graphs.html">separate page</a>.</p>
        <br/>
        <a id="gettor"/>
        <h3>Packages requested from GetTor</h3>
        <br/>
        <p>GetTor allows users to fetch Tor via email. The following
        graphs show the number of requested packages per day.</p>
        <img src="graphs/gettor/gettor-total.png"/>
        <p>More graphs about specific packages can be found on a 
        <a href="gettor-graphs.html">separate page</a>.</p>
        <br/>
        <a id="versions"/>
        <h3>Relay versions</h3>
        <br/>
        <p>Relays report the Tor version that they are running in their
        server descriptors that they send to the directory authorities.
        The following graph shows the number of relays running specific
        Tor versions.</p>
        <img src="versions.png" width=576 height=360 />
        <br/>
        <a id="platforms"/>
        <h3>Relay platforms</h3>
        <br/>
        <p>Relays further report the operating systems in their server
        descriptors that they send to the directory authorities. The
        following graph shows the number of relays running specific
        platforms.</p>
        <img src="platforms.png" width=576 height=360 />
        <br/>
        <a id="bandwidth"/>
        <h3>Relay bandwidth</h3>
        <br/>
        <p>Relays advertise how much bandwidth they are willing and
        to contribute in their server descriptors. The following graph
        shows the sum of advertised bandwidth of all relays in the
        network.</p>
        <img src="bandwidth.png" width=576 height=360 />
        <br/>
