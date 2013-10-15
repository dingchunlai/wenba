function getCidValue()
{
    var _cl1 = document.ftiwen.ClassLevel1;
    var _cl2 = document.ftiwen.ClassLevel2;
    var _cl3 = document.ftiwen.ClassLevel3;
    var _cid = document.ftiwen.cid;
    if(_cl1.value!=0) _cid.value = _cl1.value;
    if(_cl2.value!=0) _cid.value = _cl2.value;
    if(_cl3.value!=0) _cid.value = _cl3.value;
    //    if(_cid && _cid.value) userSelected();
}
var g_ClassLevel1;
var g_ClassLevel2;
var g_ClassLevel3;

function FillClassLevel1(ClassLevel1)
{
    ClassLevel1.options[0] = new Option("aa", "0");
    for(i=0; i<class_level_1.length; i++) {
        ClassLevel1.options[i] = new Option(class_level_1[i][1], class_level_1[i][0]);
    }
    //  ClassLevel1.options[0].selected = true;
    ClassLevel1.length = i;
}

function FillClassLevel2(ClassLevel2, class_level_1_id)
{
    ClassLevel2.options[0] = new Option("不选", "");
    count = 1;
    for(i=0; i<class_level_2.length; i++) {
        if(class_level_2[i][0].toString() == class_level_1_id) {
            ClassLevel2.options[count] = new Option(class_level_2[i][2], class_level_2[i][1]);
            count = count+1;
        }
    }
    ClassLevel2.options[0].selected = true;
    ClassLevel2.length = count;
}

function FillClassLevel3(ClassLevel3, class_level_2_id)
{
    ClassLevel3.options[0] = new Option("不选", "");
    count = 1;
    for(i=0; i<class_level_3.length; i++) {
        if(class_level_3[i][0].toString() == class_level_2_id) {
            ClassLevel3.options[count] = new Option(class_level_3[i][2], class_level_3[i][1]);
            count = count+1;
        }
    }
    ClassLevel3.options[0].selected = true;
    ClassLevel3.length = count;
}

function ClassLevel2_onchange()
{
    FillClassLevel3(g_ClassLevel3, g_ClassLevel2.value);
    if (g_ClassLevel3.length <= 1) {
        g_ClassLevel3.style.display = "none";
        document.getElementById("jiantou").style.display = "none";
    }
    else {
        g_ClassLevel3.style.display = "";
        document.getElementById("jiantou").style.display = "";
    }
    getCidValue();

}

function ClassLevel1_onchange()
{
    FillClassLevel2(g_ClassLevel2, g_ClassLevel1.value);
    ClassLevel2_onchange();
    getCidValue();
}

function InitClassLevelList(ClassLevel1, ClassLevel2, ClassLevel3)
{
    g_ClassLevel1=ClassLevel1;
    g_ClassLevel2=ClassLevel2;
    g_ClassLevel3=ClassLevel3;

    g_ClassLevel1.onchange = Function("ClassLevel1_onchange();");
    g_ClassLevel2.onchange = Function("ClassLevel2_onchange();");
    FillClassLevel1(g_ClassLevel1);

    var height = (g_ClassLevel1.options.length * 45 + (!(window.attachEvent && !window.opera) ? 30 : 10)) + 'px';
    g_ClassLevel1.style.height=height;
    g_ClassLevel2.style.height=height;
    g_ClassLevel3.style.height=height;
    ClassLevel1_onchange();
}