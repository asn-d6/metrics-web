/* Copyright 2016 The Tor Project
 * See LICENSE for licensing information */
package org.torproject.metrics.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class LinkServlet extends MetricServlet {

  public void doGet(HttpServletRequest request,
      HttpServletResponse response) throws IOException, ServletException {
    String requestURI = request.getRequestURI();
    if (requestURI == null || !requestURI.endsWith(".html")) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST);
      return;
    }
    String requestedId = requestURI.substring(
        requestURI.contains("/") ? requestURI.lastIndexOf("/") + 1 : 0,
        requestURI.length() - 5);
    if (!this.idsByType.containsKey("Link") ||
        !this.idsByType.get("Link").contains(requestedId)) {
      response.sendError(HttpServletResponse.SC_BAD_REQUEST);
      return;
    }
    request.setAttribute("id", requestedId);
    request.setAttribute("title", this.titles.get(requestedId));
    request.setAttribute("description",
        this.descriptions.get(requestedId));
    request.setAttribute("data", this.data.get(requestedId));
    request.setAttribute("related", this.related.get(requestedId));
    request.getRequestDispatcher("WEB-INF/link.jsp").forward(request,
        response);
  }
}

