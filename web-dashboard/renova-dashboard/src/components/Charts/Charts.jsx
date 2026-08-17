import { PieChart } from '@mui/x-charts/PieChart';
import { LineChart } from '@mui/x-charts/LineChart';
import Box from '@mui/material/Box';
import { useTranslation } from 'react-i18next';

export default function Circlechart({v1,v2,v3}){
    const [t] = useTranslation();
    localStorage.getItem("i18nextLng");
    const data = [
    { value: v1, label: t('بناء') , color:'#F07C1F' },
    { value: v2, label: t('ترميم'), color:'#3b414c' },
    { value: v3, label: t('إكساء'), color:'#b8bcbf' },
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

export function Linerchart({ data = [] }){
    const [t] = useTranslation();
    const uData = data.map(item => item.count);
    const xLabels = data.map(item => t(item.month_name));  
    return(
      <Box sx={{ width: "100%",minWidth: 650, height: 300 ,paddingRight: '35px',overflow: "visible",direction: 'ltr'}}>
            <LineChart
                series={[{ data: uData, label:t('عدد المشاريع'), area: false ,curve: "natural",}]}
                xAxis={[{ scaleType: 'point', data: xLabels, height: 60}]}
                colors={['#F07C1F']}
                sx={{
                "& .MuiChartsAxis-directionX .MuiChartsAxis-tickLabel": {
                    fontFamily: "Tajawal !important",
                    fontSize: 11,
                },
                "& .MuiChartsAxis-directionY .MuiChartsAxis-tickLabel": {
                    fontFamily: "Tajawal !important",
                    fontSize: 11,
                },
                 "& .MuiChartsLegend-label": {
                    fontFamily: "Tajawal !important",
                    fontSize: 13,
                },    
                }}
            />
     </Box>
    );
}