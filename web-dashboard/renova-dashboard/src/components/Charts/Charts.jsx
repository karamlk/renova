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

return (
        <Box
            sx={{
                width: "100%",
                height: 300,
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
                overflow: "hidden",
            }}
        >
            <PieChart
                series={[
                    {
                        data,
                        innerRadius: 60,
                        outerRadius: 100,
                    },
                ]}
                width={300}
                height={250}
                slotProps={{
                    legend: {
                        direction: "row",
                        position: {
                            vertical: "bottom",
                            horizontal: "middle",
                        },
                    },
                }}
                sx={{
                    maxWidth: "100%",
                    "& .MuiChartsLegend-label": {
                        fontSize: 14,
                        fontFamily: "Tajawal",
                    },
                }}
            />
        </Box>
    );
}


export function Linerchart({ data = [] }){
    const [t] = useTranslation();
    const uData = data.map(item => item.count);
    const xLabels = data.map(item => t(item.month_name));  
    return(
      <Box
    sx={{
        width: "100%",
        minWidth: 0,
        height: 300,
        paddingRight: {
            xs: "5px",
            sm: "15px",
            md: "35px",
        },
        overflow: "hidden",
        direction: "ltr",
        boxSizing: "border-box",
    }}
>
<LineChart
    series={[
        {
            data: uData,
            label: t("عدد المشاريع"),
            area: false,
            curve: "natural",
        }
    ]}
    xAxis={[
        {
            scaleType: "point",
            data: xLabels,
            height: 60,
        }
    ]}
    width={undefined}
    height={300}
    colors={["#F07C1F"]}
    sx={{
        width: "100%",
        maxWidth: "100%",

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