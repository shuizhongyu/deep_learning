#!/bin/bash
#数据统计



#统计test_interface输出的csv文件中各个概率段的图片数量占比
function statistic()
{
    #以概率10%为单位，统计每段的数量占比
    #file=qr.csv
    #row=5
    file=$1
    row=$2

    echo $file

    sum=`wc -l $1 |cut -d" " -f1`

    for i in {0..9}
    do
        start=$i
        finish=$[$start+1]


        if [ $start -eq 0 ]
        then
            echo -n 0%-10%
            echo -n "       "
            n=$(echo "cat $file | awk '\$$row<0.$finish' |wc -l" | bash)
            #echo $n "     " `echo "scale=3;$n/$sum"| bc`
            echo 1|awk '{printf("'$n'    %2.2f%%\n"),'$n'/'$sum'*100}'
        elif [ $start -eq 9 ]
        then
            echo -n 90%-100%
            echo -n "       "
            n=$(echo "cat $file | awk '\$$row>0.$start' |wc -l" | bash)
            #echo $n   "        " `echo "scale=3;$n/$sum"| bc`
            echo 1|awk '{printf("'$n'    %2.2f%%\n"),'$n'/'$sum'*100}'
        else
            echo -n "$start"0%-"$finish"0%
            echo -n "       "
            n=$(echo "cat $file | awk '\$$row>0.$start&&\$$row<0.$finish' |wc -l" | bash)
            #echo $n  "      " `echo "scale=3;$n/$sum"| bc`
            echo 1|awk '{printf("'$n'    %2.2f%%\n"),'$n'/'$sum'*100}'
        fi

    done
}


#统计查全率和查准率
function precision_recall()
{
    file=$1
    yes_file=$2
    no_file=$3
    row=$4


    cat $file |awk '$'$row'>0.5{printf("%s \n",$1)}' \
    |awk -F"/" '{print $NF}'\
    |tr -d "'" |tr -d " "\
    |sort >temp_yes

    cat $file |awk '$'$row'<0.5{printf("%s \n",$1)}' \
    |awk -F"/" '{print $NF}'\
    |tr -d "'" |tr -d " "\
    |sort >temp_no

    #第一位代表本来类别，第二位代表标记类别
    TP=`comm -12 temp_yes $yes_file|wc -l`
    #正确标记为负,两个的交集
    TN=`comm -12 temp_no $no_file|wc -l`
    #错误标记为正
    FP=`comm -12 temp_yes $no_file|wc -l`
    #错误标记为负
    FN=`comm -12 temp_no $yes_file|wc -l`

    rm temp_yes temp_no

    #echo $TP $TN $FP $FN
    #以第一位代表分类，第二位代表实际分类来显示
    echo -e  "--  yes no \nyes $TP $FP \nno $FN $TN" >temp
    cat temp | column -t
    rm temp


    echo yes:
    echo 1|awk '{printf("precision=%2.2f%%  "),'$TP'/('$TP'+'$FP')*100}'
    echo 1|awk '{printf("recall=%2.2f%% \n"),'$TP'/('$TP'+'$FN')*100}'
    echo no:
    echo 1|awk '{printf("precision=%2.2f%%  "),'$TN'/('$TN'+'$FN')*100}'
    echo 1|awk '{printf("recall=%2.2f%% \n"),'$TN'/('$TN'+'$FP')*100}'


    #echo yes:
    #echo -n precision=`echo "scale=4;$TP/($TP+$FP)*100"|bc|tr -d '0'`%" "
    #echo recall=`echo "scale=4;$TP/($TP+$FN)*100"|bc|tr -d '0'`%
    #echo no:
    #echo -n precision=`echo "scale=4;$TN/($TN+$FN)*100"|bc|tr -d '0'`%" "
    #echo recall=`echo "scale=4;$TN/($TN+$FP)*100"|bc|tr -d '0'`%
}

#三类版本
function precision_recall3()
{
    file=$1
    yes_file=$2
    no_file=$3
    other_file=$4
    row_yes=$5
    row_no=$6
    row_other=$7


    cat $file \
    |awk '$'$row_yes'>$'$row_no'&&$'$row_yes'>$'$row_other'{printf("%s \n",$1)}' \
    |awk -F"/" '{print $NF}'\
    |tr -d "'" |tr -d " "\
    |sort >temp_yes

    cat $file \
    |awk '$'$row_no'>$'$row_other'&&$'$row_no'>$'$row_yes'{printf("%s \n",$1)}' \
    |awk -F"/" '{print $NF}'\
    |tr -d "'" |tr -d " "\
    |sort >temp_no

    cat $file \
    |awk '$'$row_other'>$'$row_yes'&&$'$row_other'>$'$row_no'{printf("%s \n",$1)}' \
    |awk -F"/" '{print $NF}'\
    |tr -d "'" |tr -d " "\
    |sort >temp_other

    #第一位代表标记类别，第二位代表实际类别，和上面的相反了
    #echo $yes_file $no_file $other_file
    YY=`comm -12 temp_yes $yes_file|wc -l`
    YN=`comm -12 temp_yes $no_file|wc -l`
    YO=`comm -12 temp_yes $other_file|wc -l`
    NY=`comm -12 temp_no $yes_file|wc -l`
    NN=`comm -12 temp_no $no_file|wc -l`
    NO=`comm -12 temp_no $other_file|wc -l`
    OY=`comm -12 temp_other $yes_file|wc -l`
    ON=`comm -12 temp_other $no_file|wc -l`
    OO=`comm -12 temp_other $other_file|wc -l`

    rm temp_yes temp_no temp_other

    echo -e  "--  yes  no  other \nyes $YY $YN $YO \nno $NY $NN $NO \nother $OY $ON $OO" >temp
    cat temp | column -t
    rm temp



    echo ""
    echo yes:
    echo 1|awk '{printf("precision=%2.2f%%  "),'$YY'/('$YY'+'$YN'+'$YO')*100}'
    echo 1|awk '{printf("recall=%2.2f%%  \n"),'$YY'/('$YY'+'$NY'+'$OY')*100}'

    echo no:
    echo 1|awk '{printf("precision=%2.2f%%  "),'$NN'/('$NY'+'$NN'+'$NO')*100}'
    echo 1|awk '{printf("recall=%2.2f%%  \n"),'$NN'/('$NN'+'$YN'+'$ON')*100}'

    echo other:
    echo 1|awk '{printf("precision=%2.2f%%  "),'$OO'/('$OY'+'$ON'+'$OO')*100}'
    echo 1|awk '{printf("recall=%2.2f%% \n"),'$OO'/('$NO'+'$YO'+'$OO')*100}'
    echo ""

    #echo yes:
    #echo -n precision=`echo "scale=4;$YY/($YY+$YN+$YO)*100"|bc|tr -d '0'`%" "
    #echo recall=`echo "scale=4;$YY/($YY+$NY+$OY)*100"|bc|tr -d '0'`%

    #echo no:
    #echo -n precision=`echo "scale=4;$NN/($NY+$NN+$NO)*100"|bc|tr -d '0'`%" "
    #echo recall=`echo "scale=4;$NN/($NN+$YN+$ON)*100"|bc|tr -d '0'`%

    #echo other:
    #echo -n precision=`echo "scale=4;$OO/($OY+$ON+$OO)*100"|bc|tr -d '0'`%" "
    #echo recall=`echo "scale=4;$OO/($NO+$YO+$OO)*100"|bc|tr -d '0'`%
}




echo ""

case $1 in
    box*):
        if [ $2 -eq 1 ];then
            statistic box.csv 3 | column -t
        else
            echo box:
            precision_recall box.csv ../test2_result/box/box_yes ../test2_result/box/box_no 3
        fi
        ;;
    *hole):
        if [ $2 -eq 1 ];then
            statistic hole.csv 3
        else
            echo hole:
            precision_recall hole.csv ../test2_result/hole/hole_yes ../test2_result/hole/hole_no 3
        fi
        ;;
    line):
        if [ $2 -eq 1 ];then
            statistic line.csv 5
        else
            echo line:
            precision_recall3 line.csv ../test2_result/line/line_yes ../test2_result/line/line_no ../test2_result/line/line_other 5 3 7
        fi
        ;;
    qr):
        if [ $2 -eq 1 ];then
            statistic qr.csv 5
        else
            echo qr:
            precision_recall qr.csv ../test2_result/qr/qr_yes ../test2_result/qr/qr_no 5
        fi
        ;;
    hat):
        if [ $2 -eq 1 ];then
            statistic hat.csv 7
        else
            echo hat:
            precision_recall3 hat.csv ../test2_result/hat/hat_yes ../test2_result/hat/hat_no ../test2_result/hat/hat_other 7 3 5
        fi
        ;;
    *):
        echo usage:./statistic.sh box/line/hole/hat/qr 1/2
esac

#列是合格的那列
#statistic box.csv 3
#statistic qr.csv 5
#statistic hat.csv 7
#statistic hole.csv 3
#statistic line.csv 5

#echo box:
#precision_recall box.csv ../test2_result/box/box_yes ../test2_result/box/box_no 3
#echo qr:
#precision_recall qr.csv ../test2_result/qr/qr_yes ../test2_result/qr/qr_no 5
#echo hole:
#precision_recall hole.csv ../test2_result/hole/hole_yes ../test2_result/hole/hole_no 3
#echo line:
#precision_recall3 line.csv ../test2_result/line/line_yes ../test2_result/line/line_no ../test2_result/line/line_other 5 3 7
#echo hat:
#precision_recall3 hat.csv ../test2_result/hat/hat_yes ../test2_result/hat/hat_no ../test2_result/hat/hat_other 7 3 5
