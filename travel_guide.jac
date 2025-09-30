walker test_llm {
    can hello() -> str {
        py {
            from byllm.llm import Model
            llm = Model(model_name="gpt-4o-mini", api_key="sk-your-secret-key-here")
            result = llm.prompt("Hello from Jac!")
        }
        return result;
    }
}
