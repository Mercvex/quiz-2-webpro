<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="${book.title}" scope="request"/>
<c:set var="activeNav" value="books" scope="request"/>
<%@ include file="../_layout_top.jsp" %>

<section class="page-heading">
    <h1>Book Details</h1>
    <p>View the details of your book.</p>
</section>

<div class="panel book-detail">
    <c:choose>
        <c:when test="${not empty book.coverImage}">
            <img src="${pageContext.request.contextPath}/${fn:escapeXml(book.coverImage)}"
                 alt="Cover of ${fn:escapeXml(book.title)}" class="book-detail-cover">
        </c:when>
        <c:otherwise>
            <div class="book-detail-cover book-cover-placeholder">No Cover Available</div>
        </c:otherwise>
    </c:choose>

    <div class="book-detail-info">
        <h2>${fn:escapeXml(book.title)}</h2>
        <p class="muted">by ${fn:escapeXml(book.authorName)}</p>

        <p><strong>Category:</strong>
            <c:choose>
                <c:when test="${not empty book.categoryName}">${fn:escapeXml(book.categoryName)}</c:when>
                <c:otherwise>Not specified</c:otherwise>
            </c:choose>
        </p>
        <p><strong>Status:</strong> <span class="book-status">${fn:escapeXml(book.status.display)}</span></p>
        <p><strong>Pages:</strong>
            <c:choose>
                <c:when test="${book.currentPage != null and book.totalPages != null}">
                    ${fn:escapeXml(book.currentPage)} / ${fn:escapeXml(book.totalPages)} (${fn:escapeXml(book.progressPercent)}%)
                </c:when>
                <c:when test="${book.currentPage != null}">
                    Page ${fn:escapeXml(book.currentPage)} (total unknown)
                </c:when>
                <c:otherwise>Not tracked</c:otherwise>
            </c:choose>
        </p>

        <c:if test="${not empty book.summary}">
            <div class="book-summary">
                <h3>Summary</h3>
                <p>${fn:escapeXml(book.summary)}</p>
            </div>
        </c:if>

        <div class="book-file-section">
            <h3>Book File</h3>
            <c:choose>
                <c:when test="${book.hasFile()}">
                    <p><span class="file-info">${fn:escapeXml(book.originalFilename)}</span></p>
                    <a href="${pageContext.request.contextPath}/books/${fn:escapeXml(book.bookId)}/read"
                       class="primary-btn" style="margin-top:10px;display:inline-flex;">
                        📖 Read Book
                    </a>
                </c:when>
                <c:otherwise>
                    <p class="muted">No book file uploaded yet.</p>
                    <a href="${pageContext.request.contextPath}/books/${fn:escapeXml(book.bookId)}/edit"
                       class="secondary-btn" style="margin-top:8px;display:inline-flex;">
                        Upload a File
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="form-actions" style="justify-content:flex-start;flex-wrap:wrap;gap:10px;">
            <a href="${pageContext.request.contextPath}/books" class="secondary-btn">← My Books</a>
            <form action="${pageContext.request.contextPath}/books/${fn:escapeXml(book.bookId)}/favorite" method="POST">
                <button type="submit" class="secondary-btn">
                    ${isFavorite ? '★ Remove from Favorites' : '☆ Add to Favorites'}
                </button>
            </form>
            <a href="${pageContext.request.contextPath}/books/${fn:escapeXml(book.bookId)}/edit" class="primary-btn">Edit Book</a>
            <form action="${pageContext.request.contextPath}/books/${fn:escapeXml(book.bookId)}/delete" method="POST"
                  onsubmit="return confirm('Delete this book? Notes, logs, and goals will also be removed.')">
                <button type="submit" class="btn-danger">Delete Book</button>
            </form>
        </div>
    </div>
</div>

<%-- ============ Notes section ============ --%>
<section class="panel" style="margin-top:24px;">
    <div class="section-heading">
        <h2>Private Notes</h2>
    </div>

    <form action="${pageContext.request.contextPath}/notes/create?bookId=${fn:escapeXml(book.bookId)}"
          method="POST" class="note-form">
        <div class="form-group">
            <textarea class="form-control" name="content" rows="3"
                      placeholder="Write a private note about this book..." required></textarea>
        </div>
        <button type="submit" class="primary-btn">Add Note</button>
    </form>

    <c:choose>
        <c:when test="${empty notes}">
            <p class="muted empty-message" style="margin-top:16px;">No notes yet.</p>
        </c:when>
        <c:otherwise>
            <div class="notes-list" style="margin-top:16px;">
                <c:forEach var="note" items="${notes}">
                    <div class="note-item">
                        <p class="note-content">${fn:escapeXml(note.content)}</p>
                        <div class="note-meta">
                            <span class="muted" style="font-size:12px;">${fn:escapeXml(note.createdAt)}</span>
                            <div class="note-actions">
                                <a href="${pageContext.request.contextPath}/notes/${fn:escapeXml(note.noteId)}/edit">Edit</a>
                                <form action="${pageContext.request.contextPath}/notes/${fn:escapeXml(note.noteId)}/delete"
                                      method="POST" style="display:inline;"
                                      onsubmit="return confirm('Delete this note?')">
                                    <button type="submit" class="btn-link-danger">Delete</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<%-- ============ Log reading session ============ --%>
<section class="panel" style="margin-top:24px;">
    <div class="section-heading">
        <h2>Log a Reading Session</h2>
    </div>
    <form action="${pageContext.request.contextPath}/logs/create?bookId=${fn:escapeXml(book.bookId)}"
          method="POST" class="log-form">
        <div class="form-row">
            <div class="form-group">
                <label for="log_date">Date</label>
                <input class="form-control" type="date" id="log_date" name="log_date"
                       required value="${java.time.LocalDate.now()}">
            </div>
            <div class="form-group">
                <label for="pages_read">Pages Read</label>
                <input class="form-control" type="number" id="pages_read" name="pages_read"
                       min="1" required placeholder="e.g. 30">
            </div>
        </div>
        <div class="form-group">
            <label for="log_notes">Session Notes <span class="muted">(Optional)</span></label>
            <input class="form-control" type="text" id="log_notes" name="notes"
                   placeholder="Quick note about this session">
        </div>
        <button type="submit" class="primary-btn">Log Session</button>
    </form>
</section>

<%@ include file="../_layout_bottom.jsp" %>
