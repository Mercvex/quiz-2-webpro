<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="Edit Note" scope="request"/>
<c:set var="activeNav" value="books" scope="request"/>
<%@ include file="../_layout_top.jsp" %>
<section class="page-heading">
    <h1>Edit Note</h1>
    <p>For: <em>${fn:escapeXml(note.bookTitle)}</em></p>
</section>
<div class="panel">
    <form action="${pageContext.request.contextPath}/notes/${fn:escapeXml(note.noteId)}/edit" method="POST">
        <div class="form-group">
            <label for="content">Note Content *</label>
            <textarea class="form-control" id="content" name="content" rows="6"
                      required>${fn:escapeXml(note.content)}</textarea>
        </div>
        <div class="form-actions">
            <a href="${pageContext.request.contextPath}/books/${fn:escapeXml(note.bookId)}" class="secondary-btn">Cancel</a>
            <button type="submit" class="primary-btn">Save Changes</button>
        </div>
    </form>
</div>
<%@ include file="../_layout_bottom.jsp" %>
