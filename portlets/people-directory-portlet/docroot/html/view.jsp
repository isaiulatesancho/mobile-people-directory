<%--
/**
 * Copyright (C) 2005-2014 Rivet Logic Corporation.
 * 
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; version 3 of the License.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc., 51
 * Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */
--%>

<%@ include file="init.jsp"%>

<div id="<portlet:namespace/>view">
	<c:choose>
		<c:when test="<%= themeDisplay.isSignedIn() %>">
			<div id="people-directory-container">
				<aui:input type="hidden" id="maxItems" name="maxItems" value='<%= PropsValues.MAX_SEARCH_ITEMS %>' />
				
				<%
					String tabValue = ParamUtil.getString(request, Constants.TAB, Constants.SEARCH);
					PortletURL portletURL = renderResponse.createRenderURL();
					portletURL.setParameter(Constants.TAB, tabValue);
				%>
				
				<liferay-ui:tabs names="search,view-all" tabsValues="search,view"
					url='<%=portletURL.toString()%>' param="tab" />
					
				<c:choose>
					<c:when test='<%= tabValue.equals(Constants.SEARCH) %>'>
						<div id="modal"></div>
						<c:if test="<%= skypeEnabled %>">
							<div class="skype-users-to-call">
								<span class="action-header"><liferay-ui:message key="skype-actions"/></span>
								<ul id="users">
								</ul>
							    <div class="portlet-msg-error"><liferay-ui:message key="error.message.select.one.user"/></div>
							    <hr>
							    <aui:button-row>
									<aui:button name="skype-open" icon="icon-skype" value="action.open.skype"/>
									<aui:button name="skype-call" icon="icon-phone" value="action.call.skype"/>
							    </aui:button-row>
							    <div class="alredy-in-list-msg">
								    <h3 class="header"><liferay-ui:message key="error"/></h3>
									<p class="content"><liferay-ui:message key="already-in-list"/></p>							    
							    </div>
							</div>
						</c:if>
						<c:if test="<%= hangoutsEnabled %>">
							<div class="hangouts-users-to-call">
								<span class="action-header"><liferay-ui:message key="hangouts-actions"/></span>
								<ul id="hangouts-users">
								</ul>
							    <hr>
							    <aui:button-row>
							    	<div id="hangouts-button-placeholder"></div>
							    </aui:button-row>
							    <div class="alredy-in-list-msg">
								    <h3 class="header"><liferay-ui:message key="error"/></h3>
									<p class="content"><liferay-ui:message key="already-in-list"/></p>							    
							    </div>
							</div>
						</c:if>
						<div id="simpleSearchForm">
								<aui:fieldset cssClass="search-criteria">
									
									<aui:input id="<%= Constants.PARAMETER_KEYWORDS %>" name="<%= Constants.PARAMETER_KEYWORDS %>" type="text"
										cssClass="simple-search-keywords" label="people-directory.label.search-user" placeholder="people-directory.label.type-keywords"
									/>
									<c:if test="<%= skillsEnabled %>">
										<a class="toggle-search-type" href="javascript:;">
											<liferay-ui:message key="people-directory.label.search-by-skills"/>
										</a>
									</c:if>
								</aui:fieldset>
								<c:if test="<%= skillsEnabled %>">
								<aui:fieldset cssClass="skills-criteria hide">
									<form>
										<label class="control-label"><liferay-ui:message key="people-directory.label.search-skills"/></label>
										<div class="lfr-tags-selector-content" id="<portlet:namespace/>assetTagsSelector">
											<aui:input name="search-skills" type="hidden" />
											<input class="lfr-tag-selector-input" id="<portlet:namespace/>assetTagsNames" maxlength="75" size="15" title="<liferay-ui:message key="add-tags" />" type="text" />
										</div>
										<a class="toggle-search-type" href="javascript:;"><liferay-ui:message key="people-directory.label.search-by-name"/></a>
									</form>
								</aui:fieldset>
								</c:if>
						</div>
					</c:when>
	 				<c:when test='<%= tabValue.equals(Constants.VIEW) %>'>
			 			<div id="viewAll">
							<%
							    LinkedHashMap<String, Object> userParams = PeopleDirectoryUtil.getUserParams();
										String orderByCol = ParamUtil.getString(request, Constants.ORDER_BY_COL,CustomComparatorUtil.COLUMN_FIRST_NAME);
										String orderByType = ParamUtil.getString(request, Constants.ORDER_BY_TYPE, CustomComparatorUtil.ORDER_DEFAULT);
										OrderByComparator orderComparator = CustomComparatorUtil
												.getUserOrderByComparator(orderByCol, orderByType);
							%>
							<liferay-ui:search-container delta="<%= viewAllResultsPerPage %>"
								emptyResultsMessage="no-users-were-found" orderByCol="<%=orderByCol%>"
								orderByType="<%=orderByType%>" orderByColParam="orderByCol"
								orderByTypeParam="orderByType"
								orderByComparator="<%=orderComparator%>" iteratorURL='<%=portletURL%>'>
						
								<liferay-ui:search-container-results
									results="<%=UserLocalServiceUtil.search(
													company.getCompanyId(), null,
													WorkflowConstants.STATUS_APPROVED, userParams,
													searchContainer.getStart(),
													searchContainer.getEnd(),
													searchContainer.getOrderByComparator())%>"
									total="<%=UserLocalServiceUtil.searchCount(
													company.getCompanyId(), null,
													WorkflowConstants.STATUS_APPROVED, userParams)%>" />
						
								<liferay-ui:search-container-row indexVar="indexer"
									className="com.liferay.portal.model.User" keyProperty="userId" modelVar="user">
									<%
										PortletURL profileURL = renderResponse.createRenderURL();
										profileURL.setParameter(Constants.MVC_PATH, Constants.PEOPLE_DIRECTORY_PROFILE_PAGE);
										profileURL.setParameter(Constants.PARAMETER_USER_ID, String.valueOf(user.getUserId()));
										profileURL.setParameter(Constants.BACK_URL, currentURL);
										String columnHref = profileURL.toString();
									%>
									<liferay-ui:search-container-column-text name="name"
										property="fullName" orderable="true" orderableProperty="<%= CustomComparatorUtil.COLUMN_FIRST_NAME %>"
										href='<%=columnHref%>' />
											
									<liferay-ui:search-container-column-text name="email"
										property="emailAddress" orderable="true"
										orderableProperty="<%= CustomComparatorUtil.COLUMN_EMAIL_ADDRESS %>" href='<%="mailto:"+user.getEmailAddress()%>' />
						
									<liferay-ui:search-container-column-text name="job-title"
										property="jobTitle" orderable="true" orderableProperty="<%= CustomComparatorUtil.COLUMN_JOB_TITLE %>"
										href='<%=columnHref%>' />
						
									<liferay-ui:search-container-column-text name="<%= CustomComparatorUtil.COLUMN_CITY %>">
										<%=PeopleDirectoryUtil.getCityField(user)%>
									</liferay-ui:search-container-column-text>
									<liferay-ui:search-container-column-jsp name="<%= CustomComparatorUtil.COLUMN_PHONE %>" path="/html/include/phone_with_skype.jsp" />
					
								</liferay-ui:search-container-row>
						
								<liferay-ui:search-iterator />
						
							</liferay-ui:search-container>
						</div>
	 				</c:when>
				</c:choose>
				
				<div id="searchResults" class="people_paginator"></div>
				<div id="paginator"></div>
			</div>
		</c:when>
		<c:otherwise>
			<%
			SessionMessages.add(renderRequest, portletDisplay.getId() + SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_ERROR_MESSAGE);
			SessionErrors.add(renderRequest, "portlet-user-not-logged");
			%>
			<liferay-ui:error key="portlet-user-not-logged" message="portlet-user-not-logged" />
		</c:otherwise>
	</c:choose>
</div>
<aui:script>
	AUI().applyConfig({
	    groups : {
	    	'jquery': {
	    		base : '<%= request.getContextPath()%>/js/third-party/',
	            async : false,
	            modules : {
	            	'jquery': {
	                	path: 'jquery-1.6.4.min.js'
	                }
	            }
	    	},
	        'people-directory' : {
	            base : '<%= request.getContextPath()%>/js/',
	            async : false,
	            modules : {
	        		'skype-plugin-people-directory': {
	        			path: 'skype-plugin.js'
	        		},
	        		'skype-ui': {
	        			path: 'third-party/skype-uri.js'
	        		},
	        		'hangouts-plugin-people-directory': {
	        			path: 'hangouts-plugin.js'
	        		}
	            }
	        }
	    }
	});
</aui:script>
<aui:script use="people-directory-plugin,skype-plugin-people-directory,hangouts-plugin-people-directory,liferay-asset-tags-selector">
	Liferay.PeopleDirectory.init(
		{
			portletId: "<%= request.getAttribute(WebKeys.PORTLET_ID) %>",
			namespace: "<portlet:namespace/>",
			container: A.one("#<portlet:namespace/>view"),
			rowCount: "<%=searchResultsPerPage%>",
			fields: ["name", "email", "job-title", "city", "phone"],
			skillsEnabled: <%= skillsEnabled %>
		}
	);
	<c:if test="<%= skypeEnabled %>">
		Liferay.SkypePluginPeopleDirectory.init(
			{
				namespace: "<portlet:namespace/>",
				container: A.one("#<portlet:namespace/>view"),
			}
		);	
	</c:if>
	<c:if test="<%= hangoutsEnabled %>">
		Liferay.HangoutsPluginPeopleDirectory.init(
			{
				namespace: "<portlet:namespace/>",
				container: A.one("#<portlet:namespace/>view"),
			}
		);	
	</c:if>
	<c:if test="<%= skillsEnabled %>">
		Liferay.PeopleDirectory.initSkillSelector({
			allowSuggestions: true,
			contentBox: '#<portlet:namespace/>assetTagsSelector',
			groupIds: String(Liferay.ThemeDisplay.getCompanyGroupId()),
			hiddenInput: '#<portlet:namespace/>search-skills',
			input: '#<portlet:namespace/>assetTagsNames',
			portalModelResource: false
		});
		
		function toggleSearchType() {
			A.all('.skills-criteria, .search-criteria').toggleView();
		}
		
		A.all('.toggle-search-type').on('click', toggleSearchType);
	</c:if>
</aui:script>
<script src="https://apis.google.com/js/platform.js" async defer></script>
<%@ include file="include/templates.jspf"%>
