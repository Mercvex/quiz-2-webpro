<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="My Books" scope="request"/>
<c:set var="activeNav" value="books" scope="request"/>
<%@ include file="../_layout_top.jsp" %>
<!-- DEBUG favoriteIds=${fn:escapeXml(favoriteIds)} books=${books.size()} -->

<section class="page-heading">
    <h1>My Books</h1>
    <p>Browse, search, and manage your personal collection.</p>
</section>

<div class="books-toolbar">
    <form action="${pageContext.request.contextPath}/books" method="GET" class="books-filter-form">
        <input type="search" name="search" class="form-control"
               placeholder="Search by title, author, or category..."
               value="${fn:escapeXml(search)}">
        <select name="status" class="form-control">
            <option value="">All Status</option>
            <option value="Want to Read"       ${status == 'Want to Read'       ? 'selected' : ''}>Want to Read</option>
            <option value="Currently Reading"  ${status == 'Currently Reading'  ? 'selected' : ''}>Currently Reading</option>
            <option value="Finished Reading"   ${status == 'Finished Reading'   ? 'selected' : ''}>Finished Reading</option>
        </select>
        <button type="submit" class="primary-btn">Search</button>
        <c:if test="${not empty search or not empty status}">
            <a href="${pageContext.request.contextPath}/books" class="secondary-btn">Clear</a>
        </c:if>
    </form>
    <a href="${pageContext.request.contextPath}/books/create" class="primary-btn">+ Add Book</a>
</div>

<c:choose>
    <c:when test="${empty books}">
        <div class="panel empty-books">
            <h2>No books found</h2>
            <p class="muted">Your books will appear here after you add them.</p>
            <a href="${pageContext.request.contextPath}/books/create" class="primary-btn">Add Your First Book</a>
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
                        <c:if test="${not empty book.categoryName}">
                            <p class="muted" style="font-size:12px;margin-top:4px;">${fn:escapeXml(book.categoryName)}</p>
                        </c:if>
                        <div class="book-actions">
                            <a href="${pageContext.request.contextPath}/books/${fn:escapeXml(book.bookId)}">Details</a>
                            <a href="${pageContext.request.contextPath}/books/${fn:escapeXml(book.bookId)}/edit">Edit</a>
                            <form action="${pageContext.request.contextPath}/books/${fn:escapeXml(book.bookId)}/favorite" method="POST">
                                <c:set var="isFav" value="${favoriteIds.contains(book.bookId)}"/>
                                <button type="submit"
                                        class="fav-btn${isFav ? ' is-fav' : ''}"
                                        title="${isFav ? 'Remove from favorites' : 'Add to favorites'}"
                                        aria-pressed="${fn:escapeXml(isFav)}">${isFav ? '★' : '☆'}</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/books/${fn:escapeXml(book.bookId)}/delete"
                                  method="POST"
                                  onsubmit="return confirm('Delete this book? This will also remove its notes, logs, and reading goals.')">
                                <button type="submit" class="btn-danger">Delete</button>
                            </form>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="../_layout_bottom.jsp" %>
