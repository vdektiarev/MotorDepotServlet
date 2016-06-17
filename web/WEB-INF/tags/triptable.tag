<%@ tag body-content="empty" pageEncoding="UTF-8" %>
<%@ attribute name="trips" required="true" rtexprvalue="true" type="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../../bundle.jspf"%>
<table class="table">
    <thead>
    <tr>
        <th><fmt:message key="trips.table.id"/></th>
        <th><fmt:message key="trips.table.request"/></th>
        <th><fmt:message key="trips.table.driver"/></th>
        <th><fmt:message key="trips.table.accomplished"/></th>
        <c:if test="${sessionScope.user.admin}">
            <th><fmt:message key="trips.table.edit"/></th>
        </c:if>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${trips}" var="trip">
        <tr>
            <td>${trip.id}</td>
            <td><fmt:message key="requests.table.id"/>: ${trip.request.id}, <fmt:message key="requests.table.weight"/>: ${trip.request.cargoWeight}</td>
            <td>${trip.driver.user.login}</td>
            <c:choose>
                <c:when test="${trip.isComplete}">
                    <td><span class="glyphicon glyphicon-ok"></span></td>
                </c:when>
                <c:otherwise>
                    <td><span class="glyphicon glyphicon-remove"></span></td>
                </c:otherwise>
            </c:choose>
            <c:if test="${sessionScope.user.admin}">
                <td><button type="submit" class="btn btn-default" data-toggle="modal" data-target="#modal${trip.id}"><fmt:message key="trips.table.button.change_state"/></button></td>
                <div id="modal${trip.id}" class="modal fade" role="dialog">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <form action="motor_depot" method="POST">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                    <h4 class="modal-title"><fmt:message key="trips.modal.heading"/></h4>
                                </div>
                                <div class="modal-body">
                                    <p>
                                        <fmt:message key="trips.modal.text.trip"/> ${trip.id}, <fmt:message key="trips.modal.text.truck"/> ${trip.driver.truck.id}, <fmt:message key="trips.modal.text.driver"/>: ${trip.driver.user.login}
                                    </p>
                                    <p>
                                        <div class="form-group">
                                            <label for="stateList"><fmt:message key="trips.modal.text.trip_state"/></label>
                                            <select class="form-control" id="stateList" name="chosenState">
                                                <option value="true"><fmt:message key="trips.modal.select.complete"/></option>
                                                <option value="false"><fmt:message key="trips.modal.select.incomplete"/></option>
                                            </select>
                                        </div>
                                </div>
                                <div class="modal-footer">
                                    <input type="hidden" name="trip_id" value="${trip.id}"/>
                                    <input type="hidden" name="command" value="change_trip_state">
                                    <button type="submit" class="btn btn-primary"><fmt:message key="trips.modal.button.save"/></button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:if>
        </tr>
    </c:forEach>
    </tbody>
</table>