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
#4类版本
function precision_recall4()
{
    file=$1
    yes_file=$2
    no1_file=$3
    no2_file=$4
    other_file=$5
    row_yes=$6
    row_no1=$7
    row_no2=$8
    row_other=$9
    #echo $file $yes_file $no1_file $no2_file $other_file $row_yes $row_no1 $row_no2 $row_other


    cat $file \
    |awk '$'$row_yes'>$'$row_no1'&&$'$row_yes'>$'$row_no2'&&$'$row_yes'>$'$row_other'{printf("%s \n",$1)}'\
    |awk -F"/" '{print $NF}'\
    |tr -d "'" |tr -d " "\
    |sort >temp_yes

    cat $file \
    |awk '$'$row_no1'>$'$row_yes'&&$'$row_no1'>$'$row_no2'&&$'$row_no1'>$'$row_other'{printf("%s \n",$1)}'\
    |awk -F"/" '{print $NF}'\
    |tr -d "'" |tr -d " "\
    |sort >temp_no1

    cat $file \
    |awk '$'$row_no2'>$'$row_yes'&&$'$row_no2'>$'$row_no1'&&$'$row_no2'>$'$row_other'{printf("%s \n",$1)}'\
    |awk -F"/" '{print $NF}'\
    |tr -d "'" |tr -d " "\
    |sort >temp_no2

    cat $file \
    |awk '$'$row_other'>$'$row_yes'&&$'$row_other'>$'$row_no1'&&$'$row_other'>$'$row_no2'{printf("%s \n",$1)}'\
    |awk -F"/" '{print $NF}'\
    |tr -d "'" |tr -d " "\
    |sort >temp_other

    #第一位代表标记类别，第二位代表实际类别
    #echo $yes_file $no_file $other_file
    YY=`comm -12 temp_yes $yes_file|wc -l`
    YN1=`comm -12 temp_yes $no1_file|wc -l`
    YN2=`comm -12 temp_yes $no2_file|wc -l`
    YO=`comm -12 temp_yes $other_file|wc -l`

    N1Y=`comm -12 temp_no1 $yes_file|wc -l`
    N1N1=`comm -12 temp_no1 $no1_file|wc -l`
    N1N2=`comm -12 temp_no1 $no2_file|wc -l`
    N1O=`comm -12 temp_no1 $other_file|wc -l`

    N2Y=`comm -12 temp_no2 $yes_file|wc -l`
    N2N1=`comm -12 temp_no2 $no1_file|wc -l`
    N2N2=`comm -12 temp_no2 $no2_file|wc -l`
    N2O=`comm -12 temp_no2 $other_file|wc -l`

    OY=`comm -12 temp_other $yes_file|wc -l`
    ON1=`comm -12 temp_other $no1_file|wc -l`
    ON2=`comm -12 temp_other $no2_file|wc -l`
    OO=`comm -12 temp_other $other_file|wc -l`


    #rm temp_yes temp_no1 temp_no2 temp_other

    echo -e  "--  yes  no1 no2 other \nyes $YY $YN1 $YN2 $YO \nno1 $N1Y $N1N1 $N1N2 $N1O \n no2 $N2Y $N2N1 $N2N2 $N2O \nother $OY $ON1 $ON2 $OO" >temp
    cat temp | column -t
    rm temp



    echo ""
    echo yes:
    echo 1|awk '{printf("precision=%2.2f%%  "),'$YY'/('$YY'+'$YN1'+'$YN2'+'$YO')*100}'
    echo 1|awk '{printf("recall=%2.2f%%  \n"),'$YY'/('$YY'+'$N1Y'+'$N2Y'+'$OY')*100}'

    echo no1:
    echo 1|awk '{printf("precision=%2.2f%%  "),'$N1N1'/('$N1Y'+'$N1N1'+'$N1N2'+'$N1O')*100}'
    echo 1|awk '{printf("recall=%2.2f%%  \n"),'$N1N1'/('$YN1'+'$N1N1'+'$N2N1'+'$ON1')*100}'

    echo no2:
    echo 1|awk '{printf("precision=%2.2f%%  "),'$N2N2'/('$N2Y'+'$N2N1'+'$N2N2'+'$N2O')*100}'
    echo 1|awk '{printf("recall=%2.2f%%  \n"),'$N2N2'/('$YN2'+'$N1N2'+'$N2N2'+'$ON2')*100}'

    echo other:
    echo 1|awk '{printf("precision=%2.2f%%  "),'$OO'/('$OY'+'$ON1'+'$ON2'+'$OO')*100}'
    echo 1|awk '{printf("recall=%2.2f%%  \n"),'$OO'/('$YO'+'$N1O'+'$N2O'+'$OO')*100}'

    echo ""
}

#statistic line_3.csv 3
#statistic line_3.csv 5
#statistic line_3.csv 7
#statistic line_3.csv 9
#precision_recall4 line_3.csv line3/yes line3/no1 line3/no2 line3/other 5 7 9 3
#precision_recall4 line_resnet3.csv line3/yes line3/no1 line3/no2 line3/other 5 7 9 3

#exit

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
    line3):
        if [ $2 -eq 1 ];then
            statistic line_3.csv 5
        else
            echo line3:
            precision_recall4 line_3.csv line3/yes line3/no1 line3/no2 line3/other 5 7 9 3
        fi
        ;;
    line_resnet3):
        if [ $2 -eq 1 ];then
            statistic line_resnet3.csv 5
        else
            echo line_resnet3:
            precision_recall4 line_resnet3.csv line3/yes line3/no1 line3/no2 line3/other 5 7 9 3
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
