var csv = '';
$("#csv").change(function(e) {
    var file = e.target.files[0];
    var imageType = 'application/vnd.ms-excel';
    if (file.type.match(imageType)) {
        limit = 1500000;
        if(file.size>limit){
            $("#csv").val("");
            swal('File size error!','File size cannot exceed 1.5MB.','error');
        }
    } else {
        swal('File type error!','File must be in CSV format.','error');
        $("#csv").val("");
    }
});

$("#submit_button").click(function(){
    var file = $("#csv").val();

    if(file == ""){
        swal('File error!','Please choose CSV file.','error');
    }else{
        $("#submit_button").html("Uploading...");
        $("#submit_button").attr("disabled",true);
        $("#csv_form").submit();
    }    
});

$("#back_button").click(function(){
    window.location.href="/";
});

$("#search_form").submit(function(e){
    e.preventDefault();

    $("#search_result").empty();
    $("#search_result").append("<tr><td colspan='4'>Loading data...</td></tr>");            
    $("#search_button").html("Searching...");
    $("#search_button").attr("disabled",true);

    var datastring = $("#search_form").serialize();
    $.post("/search",datastring,function(result){
        $("#search_result").empty();
        console.log(result);
        if(result == null || result.length <= 0 ){
            $("#search_result").append("<tr><td colspan='4'>No data found</td></tr>");            
         }else{
            $(result).each(function(i,j){
                $("#search_result").append("<tr>\
                                                <td>" + parseInt(i+1) + "</td>\
                                                <td>" + j.id + "</td>\
                                                <td>" + j.type + "</td>\
                                                <td>" + j.timestamp + "</td>\
                                                <td>" + j.data + "</td>\
                                                <td class='badge badge-" + j.validity + "'>" + j.validity_message + "</td>\
                                            </tr>");
            });
         }
       
        $("#search_button").html("Search");
        $("#search_button").attr("disabled",false);
    });
});