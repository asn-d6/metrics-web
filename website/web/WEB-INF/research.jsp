<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="top.jsp">
  <jsp:param name="pageTitle" value="Research &ndash; Tor Metrics"/>
  <jsp:param name="navActive" value="Research"/>
</jsp:include>

    <div class="container">
      <ul class="breadcrumb">
        <li><a href="index.html">Home</a></li>
        <li class="active">Research</li>
      </ul>
    </div>

    <div class="container">
      <h1>Research <a href="#research" name="research" class="anchor">#</a></h1>
      <p>Tor started out as a research project! We encourage research on all things Tor.</p>
      <p>Look around the papers section below for some ideas on what others have researched in the past. Contact <a href="mailto:#">[some general email list here, torproject?]</a> if you want to discuss ideas.</p>

    </div>

    <div class="container">

      <h2>Feel free to use our data for your research! <a href="#use" name="use" class="anchor">#</a></h2>

      <p>If you do, please cite <a href="https://metrics.torproject.org/" target="_self">https://metrics.torproject.org/</a> or the following <a href="http://freehaven.net/anonbib/#wecsr10measuring-tor" target="_blank">paper</a>:</p>
      <p><pre>
@inproceedings{wecsr10measuring-tor,
  title = {A Case Study on Measuring Statistical Data in the {T}or Anonymity Network},
  author = {Karsten Loesing and Steven J. Murdoch and Roger Dingledine},
  booktitle = {Proceedings of the Workshop on Ethics in Computer Security Research (WECSR 2010)},
  year = {2010},
  month = {January},
  location = {Tenerife, Canary Islands, Spain},
  publisher = {Springer},
  series = {LNCS},
}</pre></p>
      <p>Thank you for acknowledging this work through a citation.</p>

    </div>

    <div class="container">

      <h2>Want to collect your own data for research? <a href="#collect" name="collect" class="anchor">#</a></h2>
      <p>Look at the <a href="sources.html">sources page</a> for services that collect Tor-related data.</p>

    </div>


    <div class="container">

      <h2>Research Papers <a href="#research" name="research" class="anchor">#</a></h2>
      <p>Here are some Tor-related papers. (...) If we're missing yours, let us know!</p>

    </div>

    <div class="container">
<ul>
<li><a href="https://torps.github.io/">TorPS</a> simulates changes to Tor's path selection algorithm using archived data.</li>
<li><a href="https://shadow.github.io/">Shadow</a> uses archived Tor directory data to generate realistic network topolog
ies.</li>
</ul>
    </div>

<jsp:include page="bottom.jsp"/>

