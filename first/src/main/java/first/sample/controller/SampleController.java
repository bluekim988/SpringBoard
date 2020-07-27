package first.sample.controller;

import java.util.Arrays;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.annotation.JsonCreator.Mode;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import first.common.common.CommandMap;
import first.sample.service.SampleService;

@Controller
public class SampleController 
{
	Logger log = Logger.getLogger(this.getClass()); //로그 찍고
	
	@Resource(name="sampleService")
	private SampleService sampleService; //샘플서비스 선언하고
	
	
	
	@RequestMapping(value="/sample/openBoardSearch.do")
	public ModelAndView openBoardSearch(CommandMap commandMap) throws Exception
	{
		ModelAndView mv = new ModelAndView("/sample/boardSearch");
		return mv;
	}
	
	
	@RequestMapping(value="/sample/openBoardList.do") //경로 맵핑해주고~
	public ModelAndView openBoardList(CommandMap commandMap) throws Exception
	{  //모델뷰 만들고 openSampleBoardList 메서드 만들고
		ModelAndView mv = new ModelAndView("/sample/boardList"); //모델뷰 객체 선언뒤 jsp파일 지정
		Map<String, Object> paramMap = commandMap.getMap();
		Map<String, Object> resultMap = sampleService.selectBoardList(paramMap);
		//List<Map<String, Object>> list = sampleService.selectBoardList(commandMap);
		//앞에서 샘플서비스 선언한것 뒤에 selectBoardList라는 메서드 만들고 
		//mv.addObject("list", list); //앞에서 실행 다하고 list에 담긴건 list라고 선언하고
		mv.addObject("paginationInfo", (PaginationInfo)resultMap.get("paginationInfo"));
		mv.addObject("list", resultMap.get("result"));
		mv.addObject("code", paramMap.get("code"));
		mv.addObject("keyword", paramMap.get("keyword"));
		System.out.println("========JRebel Test============");
		log.debug("======JRebel Test2======");
		
		return mv;
	}
	
	@RequestMapping(value="/sample/testMapArgumentResolver.do")
	public ModelAndView testMapArgumentResolver(CommandMap commandMap) throws Exception
	{
		ModelAndView mv = new ModelAndView("");
		
		if(commandMap.isEmpty() == false)
		{
			Iterator<Entry<String,Object>> iterator = commandMap.getMap().entrySet().iterator();
			Entry<String,Object> entry = null;
			while(iterator.hasNext())
			{
				entry = iterator.next();
				log.debug("key :"+entry.getKey()+", value :"+entry.getValue());
			}
		}
		
		return mv;
	}
	
	
	@RequestMapping(value="/sample/openBoardWrite.do")
	public ModelAndView openBoardWrite(CommandMap commandMap) throws Exception
	{
		
		ModelAndView mv = new ModelAndView("/sample/boardWrite");  //JSP 파일 지정
		System.out.println("========JRebel Test============");
		return mv;
	}
	
	@RequestMapping(value="/sample/Test.do")
	public ModelAndView Test(CommandMap commandMap) throws Exception
	{
		
		ModelAndView mv = new ModelAndView("/sample/Test");  //JSP 파일 지정
		System.out.println("========Test Test============");
		return mv;
	}
	
	@RequestMapping(value="/sample/kk.do")
	public ModelAndView kk(CommandMap commandMap) throws Exception
	{
		
		ModelAndView mv = new ModelAndView("/sample/kk");  //JSP 파일 지정
		System.out.println("========kk Test============");
		return mv;
	}
	
	
	
	
	@RequestMapping(value="/sample/insertBoard.do")
	public ModelAndView insertBoard(CommandMap commandMap, HttpServletRequest request) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		String view = "redirect:/sample/openBoardList.do";
		Map<String, Object> map = commandMap.getMap();
		sampleService.insertBoard(map, request);
		String parent_idx = (String)map.get("PARENT_IDX");
		if(parent_idx != null) {
			view = "redirect:/sample/openBoardDetail.do"+"?IDX="+parent_idx;
		}
		mv.setViewName(view);
		return mv;
	}
	
	@RequestMapping(value="/sample/openBoardDetail.do")
	public ModelAndView openBoardDetail(CommandMap commandMap) throws Exception
	{
		ModelAndView mv = new ModelAndView("/sample/boardDetail");
		
		Map<String,Object> map = sampleService.selectBoardDetail(commandMap.getMap());
		
		mv.addObject("map", map.get("map"));
		mv.addObject("list", map.get("list")); //요건 첨부파일 목록 부를때 쓸거임
		mv.addObject("replyList", map.get("replyList"));
		
		return mv;
	}
	
	@RequestMapping(value="/sample/openBoardUpdate.do")  //수정디테일화면
	public ModelAndView openBoardUpdate(CommandMap commandMap) throws Exception
	{
		ModelAndView mv = new ModelAndView("/sample/boardUpdate");
		
		Map<String, Object> map = sampleService.boardUpdate(commandMap.getMap());
		
		mv.addObject("map", map.get("map"));  //내용
		mv.addObject("list", map.get("list"));   //첨부파일
		
		return mv;
	}
	
	@RequestMapping(value="/sample/updateBoard.do")  //수정하기 누르는~~ 혹은 저장하기 누르는~~
	public ModelAndView updateBoard(CommandMap commandMap, HttpServletRequest request) throws Exception
	{
		ModelAndView mv = new ModelAndView("redirect:/sample/openBoardDetail.do");
		
		sampleService.updateBoard(commandMap.getMap(), request);
		
		mv.addObject("IDX", commandMap.get("IDX"));
		return mv;
	}
	
	@RequestMapping(value="/sample/deleteBoard.do")
	public ModelAndView deleteBoard(CommandMap commandMap) throws Exception
	{
		ModelAndView mv = new ModelAndView("redirect:/sample/openBoardList.do");
		
		sampleService.deleteBoard(commandMap.getMap());
		
		return mv;
	}

}
