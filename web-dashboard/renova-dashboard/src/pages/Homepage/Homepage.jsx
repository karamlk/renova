import "./Homepage.css";
//MUI
import { Grid } from '@mui/material';
//Components
import Card from "../../components/Card/Card"
import Cardchart from "../../components/Cardchart/Cardchart";
import Projecttable from "../../components/Projecttable/Projecttable";
import Circlechart from "../../components/Charts/Charts";
import {Linerchart} from "../../components/Charts/Charts";
//Hooks
import { useTranslation } from 'react-i18next';
//MUI Icons
import ApartmentIcon from '@mui/icons-material/Apartment';
import PersonIcon from '@mui/icons-material/Person';
import DoneAllIcon from '@mui/icons-material/DoneAll';
import AttachMoneyIcon from '@mui/icons-material/AttachMoney';
import DonutLargeIcon from '@mui/icons-material/DonutLarge';
import TrendingUpIcon from '@mui/icons-material/TrendingUp';
import BarChartIcon from '@mui/icons-material/BarChart';

export default function Homepage() {
    const [t] = useTranslation();
    return (
        <div>
            <Grid container spacing={2}>
                {/*Cards*/}
                <Grid size={3}>
                    <Card number="58" title={t("إجمالي المشاريع")} iconright={<ApartmentIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
                </Grid>
                <Grid size={3}>
                    <Card number="100" title={t("إجمالي المستخدمين")} iconright={<PersonIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
                </Grid>
                <Grid size={3}>
                    <Card number="25" title={t("المشاريع المكتملة")} iconright={<DoneAllIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
                </Grid>
                <Grid size={3}>
                    <Card number="25M" title={t("إجمالي الربح")} iconright={<AttachMoneyIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
                </Grid>
                {/*CardsCharts*/}
                <Grid size={12}>
                    <div className="chart-title"><BarChartIcon sx={{ color: "#f07c1f" ,fontSize:35 }}/><h3>{t("التحليل و الإحصائيات")}</h3></div>
                </Grid>
                <Grid size={6}>
                    <Cardchart title={t("نسبة المشاريع حسب النوع")} icon={<DonutLargeIcon sx={{ color: "#f07c1f" }} fontSize="medium" />}>
                        <Circlechart/>
                    </Cardchart>
                </Grid>
                <Grid size={6}>
                    <Cardchart title={t("إنجاز المشاريع")} icon={<TrendingUpIcon sx={{ color: "#f07c1f" }} fontSize="medium" />}>
                        <Linerchart/>
                    </Cardchart>
                </Grid>
                {/*Tabels*/}
                <Grid size={12}>
                    <Projecttable/>
                </Grid>
            </Grid>
        </div>
    )
}