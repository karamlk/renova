import { PieChart } from '@mui/x-charts/PieChart';
import { LineChart } from '@mui/x-charts/LineChart';
import Box from '@mui/material/Box';
export default function Circlechart(){
    const data = [
    { value: 9, label: 'بناء' , color:'#F07C1F' },
    { value: 10, label: 'ترميم', color:'#3b414c' },
    { value: 15, label: 'إكساء', color:'#b8bcbf' },
    ];
    const size = {
        width: 300,
        height: 250,
    };
    return(
        <PieChart 
        series={[{ data, innerRadius: 60,outerRadius: 100, }]}
        {...size}
        slotProps={{legend: {direction: 'row',position: {vertical: 'bottom',horizontal: 'middle',},},}} 
        sx={{"& .MuiChartsLegend-label": {fontSize: 14,fontFamily: "Tajawal",},}} 
        />
    );
}

export function Linerchart(){
    const uData = [0, 5, 10, 15, 20, 25, 30,35,40,45,50,55];
    const xLabels = ['يناير','فبراير','مارس','ابريل','ماي','يونيو','يوليو','اغسطس','سبتمبر','اكتوبر','نوفمبر','ديسمبر'];
    return(
      <Box sx={{ width: "100%", height: 300 ,direction: 'ltr',paddingRight: '35px'}}>
            <LineChart
                series={[{ data: uData, label: 'عدد المشاريع', area: false ,curve: "natural",}]}
                xAxis={[{ scaleType: 'point', data: xLabels, height: 60 }]}
                colors={['#F07C1F']}
                slotProps={{axisTickLabel: {style: {fill: "#3b414c",fontFamily: "Tajawal",},},}}
                sx={{'& .MuiChartsAxis-tickLabel': {fontSize: 11,transform: 'rotate(-30deg)',textAnchor: 'end',},}}
            />
     </Box>
    );
}