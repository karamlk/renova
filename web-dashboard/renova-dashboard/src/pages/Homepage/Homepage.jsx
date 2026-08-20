import "./Homepage.css";
//MUI
import { Grid } from '@mui/material';
//Components
import Card from "../../components/Card/Card"
import Cardchart from "../../components/Cardchart/Cardchart";
import Circlechart from "../../components/Charts/Charts";
import {Linerchart} from "../../components/Charts/Charts";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState, useEffect,useContext } from "react";
//MUI Icons
import ApartmentIcon from '@mui/icons-material/Apartment';
import PersonIcon from '@mui/icons-material/Person';
import DoneAllIcon from '@mui/icons-material/DoneAll';
import AttachMoneyIcon from '@mui/icons-material/AttachMoney';
import DonutLargeIcon from '@mui/icons-material/DonutLarge';
import TrendingUpIcon from '@mui/icons-material/TrendingUp';
import BarChartIcon from '@mui/icons-material/BarChart';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import AssignmentIcon from '@mui/icons-material/Assignment';
//api
import {getDashboardRequest} from "../../api/homepage";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//Utils
import {formatMoney} from "../../utils/formatMoney";
//Libraries
import dayjs from "dayjs";
export default function Homepage() {
    const [t] = useTranslation();
    const [dashboard_info, setdashboard_info] = useState({
    counters: {},
    project_type_percentages: {},
    monthly_completions: [],
    latest_projects: []
});
    let type={restoration:t("ترميم") , construction:t("بناء") , finishing:t("إكساء")};
    let status={active:t("نشط"), completed:t("مكتمل"), cancelled:t("ملغي")}
    const {setisloading}=useContext(LoadingContext);
    //Request
    async function getDashboard() {
        setisloading(true);
        let response = await getDashboardRequest();
        
        await setdashboard_info(response.data);
        setisloading(false);
    }
    useEffect(() => {
        getDashboard();
    }, []);
    return (
        <div>
            <Grid container spacing={2}>
                {/*Cards*/}
                <Grid size={{ xs: 12, sm: 6, md: 3 }}>
                    <Card number={dashboard_info?.counters?.total_projects} title={t("إجمالي المشاريع")} iconright={<ApartmentIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
                </Grid>
                <Grid size={{ xs: 12, sm: 6, md: 3 }}>
                    <Card number={dashboard_info?.counters?.total_users} title={t("إجمالي المستخدمين")} iconright={<PersonIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
                </Grid>
                <Grid size={{ xs: 12, sm: 6, md: 3 }}>
                    <Card number={dashboard_info?.counters?.completed_projects} title={t("المشاريع المكتملة")} iconright={<DoneAllIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
                </Grid>
                <Grid size={{ xs: 12, sm: 6, md: 3 }}>
                    <Card number={`${formatMoney(dashboard_info?.counters?.total_profit)}$`} title={t("إجمالي الربح")} iconright={<AttachMoneyIcon sx={{ color: "#f07c1f" }} fontSize="large" />} />
                </Grid>
                {/*CardsCharts*/}
                <Grid size={12}>
                    <div className="chart-title"><BarChartIcon sx={{ color: "#f07c1f" ,fontSize:35 }}/><h3>{t("التحليل و الإحصائيات")}</h3></div>
                </Grid>
                <Grid size={{ xs: 12, md: 6 }}>
                    <Cardchart title={t("نسبة المشاريع حسب النوع")} icon={<DonutLargeIcon sx={{ color: "#f07c1f" }} fontSize="medium" />}>
                        <Circlechart 
                        v1={dashboard_info?.project_type_percentages?.construction} 
                        v2={dashboard_info?.project_type_percentages?.restoration} 
                        v3={dashboard_info?.project_type_percentages?.finishing}/>
                    </Cardchart>
                </Grid>
                <Grid size={{ xs: 12, md: 6 }}>
                    <Cardchart title={t("إنجاز المشاريع")} icon={<TrendingUpIcon sx={{ color: "#f07c1f" }} fontSize="medium" />}>
                        <Linerchart data={dashboard_info?.monthly_completions}/>
                    </Cardchart>
                </Grid>
                {/*Tabels*/}
                <Grid size={12}>
                    <div class="table-body">
                        <div class="table-header">
                            <h3><AssignmentIcon sx={{ color: "#f07c1f"}}/> {t("أحدث المشاريع")}</h3>
                        </div>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>{t("اسم المشروع")}</th>
                                        <th>{t("صاحب المشروع")}</th>
                                        <th>{t("الموقع")}</th>
                                        <th>{t("النوع")}</th>
                                        <th>{t("الحالة")}</th>
                                        <th>{t("تاريخ الإنشاء")}</th>
                                        <th>{t("التقدم")}</th>
                                    </tr>
                                </thead>
                            <tbody>
                                {dashboard_info?.latest_projects.map((project) => (
                                    <tr key={project.id}>
                                    <td>{project.title}</td>
                                    <td>{project.user_name}</td>
                                    <td ><div className="location"><LocationOnIcon sx={{ color: "#f07c1f"}}/>{project.location}</div></td>
                                    <td>{type[project.type]}</td>
                                    <td>{status[project.status]}</td>
                                    <td>{project.created_at?dayjs(project?.created_at).format("YYYY-MM-DD"):"-"}</td>
                                    <td>
                                        <div className="progress">
                                        <div className="progress-bar">
                                            <div className="progress-fill" style={{ width: `${project.progress}%` }}></div>
                                        </div>
                                        <span>{project.progress}%</span>
                                        </div>
                                    </td>
                                    </tr>
                                ))}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </Grid>
            </Grid>
        </div>
    )
}