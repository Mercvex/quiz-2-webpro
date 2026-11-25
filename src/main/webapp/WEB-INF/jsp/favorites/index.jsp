<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="My Favorites" scope="request"/>
<c:set var="activeNav" value="favorites" scope="request"/>
<%@ include file="../_layout_top.jsp" %>

<section class="page-heading">
    <h1>My Favorites</h1>
    <p>Books you have starred in your personal collection.</p>
</section>

<c:choose>
    <c:when test="${empty books}">
        <div class="panel empty-books">
            <h2>No favorites yet</h2>
            <p class="muted">Star a book on the My Books page or its detail page to add it here.</p>
            <a href="${pageContext.request.contextPath}/books" class="primary-btn">Browse My Books</a>
        </div>
    </c:when>
    <c:otherwise>
        <div class="books-grid">
            <c:forEach var="book" items="${books}">
                <article class="book-card">
                    <c:choose>
                        <c:when test="${not empty book.coverImage}">
                            <div class="book-cover">
                                <img src="${pageContext.request.contextPath}/${fn:escapeXml(book.coverImage)}"
                                     alt="Cover of ${fn:escapeXml(book.title)}">
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="book-cover book-cover-placeholder">No Cover Available</div>
                        </c:otherwise>
                    </c:choose>
                    <div class="book-info">
                        <h2 class="book-title">${fn:escapeXml(book.title)}</h2>
                        <p class="book-author">${fn:escapeXml(book.authorName)}</p>
                        <span class="book-status">${fn:escapeXml(book.status.display)}</span>
                        <div class="book-actions">
                            <a href="${pageContext.request.contextPath}/books/${fn:escapeXml(book.bookId)}/edit">
                                    Edit
                                </a>
                            <form action="${pageContext.request.contextPath}/books/${fn:escapeXml(book.bookId)}/favorite"
                                method="POST">
                                <button type="submit" title="Remove from favorites">
                                    ★ Remove
                                </button>
                            </form>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="../_layout_bottom.jsp" %>
