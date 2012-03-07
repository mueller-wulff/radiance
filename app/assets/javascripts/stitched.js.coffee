Stitched = -> 
     #dom element names (for easy adjustment)
    
     #PAGE EDIT
     PAGE_CONTENT_ELEMENTS = "#contentElements"
     PREVIEW_LINK = "#preview_link"
     
     #MODULE EDIT
     SORTABLE_PAGES = "#modules tbody"
     UNITS = "#modules"
     UNIT = ".module"
     PAGE = ".unit_page"
     UNIT_PAGES_SORTABLE = ".module tbody"
     
     #UNIVERSAL   
     PAGE_TITLE = "#page_title"  
 
     #setting state vars
     edit_mode = false
     progress_indicator = false
     drag_delay = 200
     pages = null
     units = null
     move_or_copy = false
     
     #Return a helper with preserved width of cells
     fixHelper = (e, ui) ->
         ui.children().each -> 
             $(this).width($(this).width())
         ui
         
     checkForProgressIndicator = ->
         if((progress_indicator)&&(!$(PAGE_TITLE).hasClass('progress')))
             $(PAGE_TITLE).addClass('progress')
         else if(!progress_indicator)
             $(PAGE_TITLE).removeClass('progress')
         
         setTimeout('Stitched.checkForProgressIndicator()', 100)
         return
     
     deleteContentElement = (id) ->
         progress_indicator = true
         $("#"+id).fadeOut('fast')
         $.ajax
             type: "DELETE"
             url: $(PAGE_CONTENT_ELEMENTS).find('[name=page]').val()+"/"+id
             data: "format=js"
             success: (returnValue) ->
                 $("#"+id).remove()
                 progress_indicator = false
                 return
             
             error: (returnValue) ->
                 alert(returnValue)
                 return
         return                      
 
     createElement = (url,klass,appendDiv,callback) ->
         progress_indicator = true         
         $.ajax
             type: "POST"
             url: url
             data: "element_type=" + klass
             success: (returnValue) ->
                 $('#empty_warning').remove()
                 $(returnValue).hide().appendTo(appendDiv).fadeIn('slow')
                 if(typeof callback == 'function')
                     callback.call()               
                 progress_indicator = false
                 return
                              
             error: (returnValue) ->
                 alert(returnValue)
                 return
         return
      
     closeAndSaveEditView = (div, callback) ->
         options =
             success: (returnValue) ->                 
                 #destroy all instances...just removing div from dom doesn't work
                 `for (instance in CKEDITOR.instances){
         		        CKEDITOR.instances[instance].destroy();
         		  }`
                 
                 div.replaceWith(returnValue)
                 $(PREVIEW_LINK).fadeIn("fast")
                 div.removeClass("editmode")
                 edit_mode = false
                 progress_indicator = false
                 if(typeof callback == 'function')
                     callback.call() 
                 return                            
             error: (returnValue) -> 
                 alert(returnValue)
                 return
         #save changes
         `for (instance in CKEDITOR.instances){
 		        CKEDITOR.instances[instance].updateElement();
 		  }`
         
         div.find("form").ajaxForm(options)
         progress_indicator = true
         div.find("form").trigger("submit")
         div.unbind('mouseenter mouseleave')
         $('body').unbind('mouseup')
         return false
 
     switchToEditView = (div,url,callback) ->
         edit_mode = true
         $.ajax
             async: false
             type: "GET"
             url: url
             success: (returnValue) ->
                 div.html(returnValue)
                 div.addClass("editmode")
                 addSaveBtnListener(div,callback)
                 addSubmitListener(div,callback)
                 $(PREVIEW_LINK).fadeOut("fast")
                 div.removeClass("element")
                 div.addClass("active-element")
                 if(typeof callback == 'function')
                     callback.call()
                 return
             error: (returnValue) ->
                 alert(returnValue)
                 return
         return
     
     sendDataToServer =  (data,url,callback) -> 
         if(!move_or_copy)
             progress_indicator = true
             $.ajax
                 type: "POST"
                 url: url
                 data: data 
                 success: (returnValue) ->
                     progress_indicator = false
                     if(typeof callback == 'function')
                         callback(returnValue)
                     return
                 error: (returnValue) ->
                     alert(returnValue)
                     return
             return             
             
     addSubmitListener =  (div,callback) ->  
         div.find("input[type=text]").bind "keydown", (l) ->
             if l.keyCode == 13 || l.keyCode == 28
                 closeAndSaveEditView(div,callback)
                 return false
             true
         return

     addSaveBtnListener = (div,callback) ->
         $(".save").click ->
             closeAndSaveEditView(div,callback)
             return false
         return
         
     bindCopyKey = (event, ui) ->         
         getPageIndizes()
         $('body').bind "keydown", (l) ->
             if l.keyCode == 18
                 ui.item.find(".page").addClass('copy')
                 return
         $('body').bind "keyup", (l) ->
             if l.keyCode == 18
                 ui.item.find(".page").removeClass('copy')
                 return
         return
     
     unbindCopyKey = ->
         $('.copy').removeClass('copy')
         $('body').unbind("keydown keyup")
         return     
 
     checkForCopyOrMove = (event, ui) ->         
         #prepare
         unbindCopyKey()
        
         isACopy = event.altKey == true
     
         page_id = ui.item.attr('id').replace('page_','')
         new_unit_id = ui.item.closest(UNIT).attr('id').replace('unit_', '')
         data = 'page_id=' + page_id + '&new_unit_id=' + new_unit_id
         
         if isACopy
             #copy happens here
             reciever = ui.item.closest(UNIT_PAGES_SORTABLE)
             getPageIndizes()
             newIndex = $(ui.item[0]).data('previousIndex')
 
             $(ui.sender).sortable('cancel')
             #send stuff to server
             sendDataToServer data, $(UNITS).find('[name=page_copy_url]').val(), (new_page) ->         
 
                     #Insert the clone into the same index it was previously
                     if newIndex == 0
                         reciever.prepend(new_page)
                     else
                         $('tr:eq(' + (newIndex - 1) + ')', reciever).after(new_page)
                     move_or_copy = false
                     sendSortedPagesToServer(reciever)
                     return
         else
             #move is here
             sendDataToServer data, $(UNITS).find('[name=page_move_url]').val(), ->
                     move_or_copy = false
                     #update the old an the new unit
                     sendSortedPagesToServer(ui.item)
                     sendSortedPagesToServer(ui.sender)
                     return
         move_or_copy = true
         return
         
     getPageIndizes = ->
         pages.each ->
             $('tr', this).each (index) ->
                 $(this).data('previousIndex', index)
                 return
             return
         return
         
     getUnitIndizes = ->
         units.each ->
             $(UNIT, this).each (index) ->
                 $(this).data('previousIndex', index)
                 return
             return
         return              
     
     sendSortedPagesToServer = (page, ui) ->
         unbindCopyKey()
         if ui
             page = ui.item             
         if(page.closest(UNIT_PAGES_SORTABLE).sortable('serialize') != [])
             sendDataToServer(page.closest(UNIT_PAGES_SORTABLE).sortable('serialize'),page.closest(UNIT).find('[name=pages_order_url]').val())
         return
     
     sendSortedUnitsToServer =  (event, ui) ->
         sendDataToServer($(UNITS).sortable('serialize'),$(UNITS).find('[name=unit_order_url]').val())
         return
     
     sendSortedModulesToServer = (event, ui) ->
         sendDataToServer($('#module_list tbody').sortable('serialize'),$('#module_list_table').find('[name=modules_order_url]').val())
         return
     
     sendSortedContentToServer = (event, ui) ->
         sendDataToServer($(PAGE_CONTENT_ELEMENTS).sortable('serialize'),$(PAGE_CONTENT_ELEMENTS).find('[name=contents_order_url]').val())
         return
     
     makeSortableModules = ->
         $("#module_list tbody" ).sortable
             delay: drag_delay
             helper: fixHelper
             stop: sendSortedModulesToServer
             
         $( "#thead tr" ).disableSelection()
         return
     
     makeSortableUnits = ->
         units = $(UNITS)
         units.sortable
             delay: drag_delay
             forcePlaceholderSize: "true"
             placeholder: "ui-state-highlight"
             stop: sendSortedUnitsToServer
         return
     
     makeSortablePages = ->
         pages = $(SORTABLE_PAGES)
         pages.sortable
             delay: drag_delay
             helper: fixHelper
             start: bindCopyKey
             receive: checkForCopyOrMove
             forcePlaceholderSize: "true"
             placeholder: "ui-state-highlight"
             connectWith: SORTABLE_PAGES
             stop: sendSortedPagesToServer 
         return
     
     makePageContentSortable = ->
         $(PAGE_CONTENT_ELEMENTS ).sortable
             delay: drag_delay
             forcePlaceholderSize: "true"
             placeholder: "ui-state-highlight"
             stop: sendSortedContentToServer
         return
     
     getPageLink = (page) ->
         "/developer/stitch_units/"+page.closest(UNIT).attr('id').match(/\d+/)+"/pages/"+page.closest(PAGE).attr('id').match(/\d+/)  

     bindRailsDeleteCallbacks = ->
         $('.delete_unit').live 'ajax:success', ->
             $(this).closest('div').fadeOut 'slow', ->
                 $(this).closest('div').remove()
                 return
             return

         $('.delete_page').live 'ajax:success', -> 
             $(this).closest('tr').fadeOut 'slow', ->
                 $(this).closest('tr').remove()
                 return
             return
         return
     
     hideAllPages = ->
         $(PAGE).css
             "display":"none"
             
         $("#create_page").css
             "display":"none"
             
         open_unit_id = $(UNITS).find('[name=open_unit]').val()
         if open_unit_id != ""
             openUnit $("#unit_"+open_unit_id)
         return
     
     bindEditPageLinks = ->
         $('.edit_page').live 'click', ->            
             if !edit_mode
                 #$(this).attr("href") will not work cause of mv between units
                 switchToEditView($(this).closest(PAGE), getPageLink($(this))+"/ajax_edit")
             false
         return
     
     bindCopyPageLinks = ->
         $('.copy_page').live 'click', ->
             getPageIndizes()
             page = $(this).closest(PAGE)
             sender = $(this).closest(UNIT_PAGES_SORTABLE)
             unit = $(this).closest(UNIT)
             data = "page_id="+page.attr('id').match(/\d+/)
             url = $(this).attr('href')
                          
             sendDataToServer(
                 data,
                 $(this).attr('href'),
                 (new_page) ->                                      
                     previousIndex = $(page).data('previousIndex')
         
                     #Insert the clone into the same index it was previously
                     if previousIndex == 0 
                         sender.prepend(new_page)
                     else
                         $('tr:eq(' + (previousIndex - 1) + ')', sender).after(new_page)
                     move_or_copy = false
                     sendSortedPagesToServer(sender)
                     return
             )
             move_or_copy = true
             false
         return
     
     bindEditUnitLinks = ->
         $('.edit_unit').live 'click', ->
             if !edit_mode
                 switchToEditView $(this).closest('div'), $(this).attr("href"), ->
                     makeSortablePages()
                     return
             false
         return
     
     bindCopyUnitLinks = ->
         $('.copy_unit').live 'click', ->
             getUnitIndizes()
             
             sender = $(this).closest(UNITS)             
             unit = $(this).closest(UNIT)
             data = "unit_id="+unit.attr('id').match(/\d+/)             
             url = $(this).attr('href')             
             
             sendDataToServer(
                 data,
                 $(this).attr('href'), 
                 (new_unit) ->
                     previousIndex = $(unit).data('previousIndex')         
                     #Insert the clone into the same index it was previously 
                     $('.module:eq(' + (previousIndex ) + ')', sender).after(new_unit) 
                     makeSortablePages()                     
                     move_or_copy = false
                     sendSortedUnitsToServer()
                     return
             )
             move_or_copy = true
             false
         return
     
     bindViewPageLinks = ->      
         $('.edit_page_link').live 'click', ->
             if !edit_mode
                 #window.location = $(this).attr('href')
                 window.location = getPageLink($(this))+"/edit"
             false
         $('.page').live 'click', ->
             if !edit_mode
                 window.location = getPageLink($(this).children('.edit_page_link'))+"/edit"
             return
         return
             
     openUnit = (item) ->
         $('.active-module').removeClass('active-module')
         item.closest(UNIT).addClass('active-module')
         item.closest(UNIT).find(PAGE).css
             "display":"table-row"
         $("#create_page").fadeIn()
         return
     
     closeUnit = ->
         $('.active-module').find(PAGE).css
             "display":"none"
         $('.active-module').removeClass('active-module')
         #hide new page link
         $("#create_page").fadeOut()
         return
     
     bindOpenUnitLinks = ->
         $('.unit_head').live 'click', ->
             if !edit_mode
                 if $(this).closest(UNIT).hasClass('active-module')
                     closeUnit()
                 else
                     openUnit $(this) 
             return false
         return
     
     bindNewElementLinks = ->
         $('.newElement').live 'click', ->             
             createElement $(this).find('[name=url]').val(), "" , UNITS, ->
                 makeSortablePages()
                 sendSortedUnitsToServer()
                 return                                     
             return false

         $('.newPage').live 'click', ->
             if $('.active-module').length == 1
                 createElement($('.active-module').find('[name=pages_url]').val(), "" ,'.active-module .module_table')
             else
                 alert("Please select a Unit first!")
             return false                      
         return     
     
     bindNewContentLinks = ->
         $('.newContentElement').live 'click', ->
             createElement(
                 $(this).parent().find('[name=url]').val(), 
                 $(this).find('[name=klass]').val(), 
                 PAGE_CONTENT_ELEMENTS, ->
                     sendSortedContentToServer()
                     return
             )
             return false
         return    
     
     bindEditContentLinks = ->
         $('.element').live 'click', ->
             if !edit_mode 
                 switchToEditView(
                     $(this),
                     $(this).find('[name=url]').val(), ->
                         toggleSortable $(PAGE_CONTENT_ELEMENTS)
                         return
                     )
                 return
         return   
         
     bindAnswerContentLinks = ->
         $('.element').live 'click', ->
              if !edit_mode 
                  switchToEditView(
                      $(this),
                      $(this).find('[name=url]').val()
                      )
                  return                  
         return
    
     bindDeleteContentLinks = ->
         $('.element .trash').live 'click', ->
             if !edit_mode
                 deleteContentElement($(this).closest('.element').attr("id"))             
             return false
         return

     toggleSortable = (selector) ->
         if edit_mode
             selector.sortable("disable")
         else
             selector.sortable("enable")
         return
     
     bindHeadlineAccordion = ->
         $('h3').click( -> 
             $(this).next().toggle('slow')
             return false
         ).next().hide()
         return

     linkCKLinks = ->
         $('a[_cke_saved_href]').each -> 
             $(this).attr('href', $(this).attr('_cke_saved_href'))
             return
         return
         
     changeAssignmentValue = ->
         $('.assignment_check').click ->
             url = $(this).data('href')
             data = 'page_assignment=' + $('#page_assignment').is(':checked')
             sendDataToServer(data, url)
             return
         return
          
     #Page View Functions
     loadCourseView = ->
         makeSortableModules()
         checkForProgressIndicator()
         return
              
     loadPageEditView = ->
         bindNewContentLinks()
         bindEditContentLinks()
         bindDeleteContentLinks()          
         makePageContentSortable()
         checkForProgressIndicator()  
         return       
     
     loadModuleEditView = ->
         hideAllPages()         
         bindEditPageLinks()
         bindEditUnitLinks()
         bindViewPageLinks()
         bindOpenUnitLinks()
         bindNewElementLinks()         
         bindCopyPageLinks()
         bindCopyUnitLinks()         
         bindRailsDeleteCallbacks()
         makeSortableUnits()
         makeSortablePages()
         checkForProgressIndicator()  
         return   
     
     loadModulePreView = ->
         hideAllPages()
         bindOpenUnitLinks()
         bindViewPageLinks()
         return
         
     loadTutorModuleView = ->
          hideAllPages()
          bindOpenUnitLinks()
          return
         
     loadFAQView = ->
         bindHeadlineAccordion()
         return
         
     loadPageAnswerView = ->
         bindAnswerContentLinks()
         checkForProgressIndicator()
         return
     
     loadPageEditView: loadPageEditView,
     loadModuleEditView: loadModuleEditView,
     loadModulePreView: loadModulePreView,
     loadTutorModuleView: loadTutorModuleView,
     loadCourseView: loadCourseView,
     loadFAQView: loadFAQView,
     linkCKLinks: linkCKLinks,
     checkForProgressIndicator: checkForProgressIndicator,
     changeAssignmentValue: changeAssignmentValue,
     loadPageAnswerView: loadPageAnswerView

root = exports ? this
root.Stitched = Stitched()