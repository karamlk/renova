import "./Homepage.css";
import Card from "../../components/Card/Card"
import { Grid } from '@mui/material';
import Cardchart from "../../components/Cardchart/Cardchart";
import Projecttable from "../../components/Projecttable/Projecttable";
import Circlechart from "../../components/Charts/Charts";
import {Linerchart} from "../../components/Charts/Charts";

//MUI Icons
import ApartmentIcon from '@mui/icons-material/Apartment';
import PersonIcon from '@mui/icons-material/Person';
import DoneAllIcon from '@mui/icons-material/DoneAll';
import AttachMoneyIcon from '@mui/icons-material/AttachMoney';
import DonutLargeIcon from '@mui/icons-material/DonutLarge';
import TrendingUpIcon from '@mui/icons-material/TrendingUp';
import BarChartIcon from '@mui/icons-material/BarChart';

export default function Homepage() {
    return (
        <div>
            <Grid container spacing={2}>
                {/*Cards*/}
                <Grid size={3}>
                    <Card number="58" title="إجمالي المشاريع" iconright={<ApartmentIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
                </Grid>
                <Grid size={3}>
                    <Card number="100" title="إجمالي المستخدمين" iconright={<PersonIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
                </Grid>
                <Grid size={3}>
                    <Card number="25" title="المشاريع المكتملة" iconright={<DoneAllIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
                </Grid>
                <Grid size={3}>
                    <Card number="25M" title="إجمالي الربح" iconright={<AttachMoneyIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
                </Grid>
                {/*CardsCharts*/}
                <Grid size={12}>
                    <div className="chart-title"><BarChartIcon sx={{ color: "#f07c1f" ,fontSize:35 }}/><h3>التحليل و الإحصائيات</h3></div>
                </Grid>
                <Grid size={6}>
                    <Cardchart title="نسبة المشاريع حسب النوع" icon={<DonutLargeIcon sx={{ color: "#f07c1f" }} fontSize="medium" />}>
                        <Circlechart/>
                    </Cardchart>
                </Grid>
                <Grid size={6}>
                    <Cardchart title="إنجاز المشاريع" icon={<TrendingUpIcon sx={{ color: "#f07c1f" }} fontSize="medium" />}>
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