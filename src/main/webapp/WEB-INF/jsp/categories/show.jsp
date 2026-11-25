<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="${category.name}" scope="request"/>
<c:set var="activeNav" value="categories" scope="request"/>
<%@ include file="../_layout_top.jsp" %>
<section class="page-heading">
    <h1>${fn:escapeXml(category.name)}</h1>
    <p>${not empty category.description ? fn:escapeXml(category.description) : 'No description.'}</p>
</section>
<div class="form-actions" style="justify-content:flex-start;margin-bottom:20px;">
    <a href="${pageContext.request.contextPath}/categories" class="secondary-btn">← Categories</a>
    <a href="${pageContext.request.contextPath}/categories/${fn:escapeXml(category.categoryId)}/edit" class="primary-btn">Edit</a>
</div>
<div class="panel">
    <div class="section-heading"><h2>Books in ${fn:escapeXml(category.name)}</h2></div>
    <c:choose>
        <c:when test="${empty books}">
            <p class="muted">No books in this category yet.</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="b" items="${books}">
                <a href="${pageContext.request.contextPath}/books/${fn:escapeXml(b.bookId)}" class="recent-book">
                    <div class="recent-book-info">
                        <h3>${fn:escapeXml(b.title)}</h3>
                        <p class="muted">${fn:escapeXml(b.authorName)}</p>
                        <span class="book-status">${fn:escapeXml(b.status.display)}</span>
                    </div>
                </a>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>
<%@ include file="../_layout_bottom.jsp" %>
